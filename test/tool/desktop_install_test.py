"""Check build/install orchestration with tiny bundles instead of Flutter builds."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


PROJECT = Path(__file__).resolve().parents[2]


class DesktopInstallTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="flood-install-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.project = self.root / "project with spaces"
        self.project.mkdir()
        for name in (
            "justfile",
            "linux/install-desktop.sh",
            "linux/ca.cleaver.flood.desktop",
            "macos/install-desktop.sh",
            "assets/icons/flood.svg",
        ):
            source = PROJECT / name
            if source.exists():
                target = self.project / name
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, target)

        commands = self.root / "commands"
        commands.mkdir()
        (commands / "uname").write_text(
            '#!/bin/sh\nprintf "%s\\n" "$FLOOD_TEST_PLATFORM"\n'
        )
        (commands / "uname").chmod(0o755)
        flutter = commands / "flutter"
        flutter.write_text('''#!/usr/bin/env python3
from pathlib import Path
import shutil
import sys
assert sys.argv[1:] in (["build", "linux", "--release"], ["build", "macos", "--release"])
Path("flutter-call").write_text(" ".join(sys.argv[1:]))
if sys.argv[2] == "linux":
    bundle = Path("build/linux/x64/release/bundle")
    (bundle / "share/applications").mkdir(parents=True, exist_ok=True)
    (bundle / "share/icons/hicolor/scalable/apps").mkdir(parents=True, exist_ok=True)
    shutil.copy("linux/ca.cleaver.flood.desktop", bundle / "share/applications")
    shutil.copy("assets/icons/flood.svg", bundle / "share/icons/hicolor/scalable/apps/ca.cleaver.flood.svg")
    executable = bundle / "flood"
else:
    bundle = Path("build/macos/Build/Products/Release/flood.app")
    (bundle / "Contents/MacOS").mkdir(parents=True, exist_ok=True)
    (bundle / "Contents/Resources").mkdir(parents=True, exist_ok=True)
    (bundle / "Contents/Info.plist").write_text("fixture plist")
    (bundle / "Contents/Resources/AppIcon.icns").write_bytes(b"fixture icon")
    link = bundle / "Contents/icon-link"
    if not link.exists():
        link.symlink_to("Resources/AppIcon.icns")
    executable = bundle / "Contents/MacOS/flood"
executable.write_text("#!/bin/sh\\nexit 0\\n")
executable.chmod(0o755)
''')
        flutter.chmod(0o755)
        self.environment = dict(
            os.environ,
            PATH=f"{commands}:{os.environ['PATH']}",
            XDG_DATA_HOME=str(self.root / "desktop data"),
            FLOOD_APPLICATIONS_DIR=str(self.root / "Applications"),
        )

    def install(self, platform):
        result = subprocess.run(
            ["just", "install"],
            cwd=self.project,
            env=dict(self.environment, FLOOD_TEST_PLATFORM=platform),
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_linux_builds_release_and_registers_launcher_and_icon(self):
        self.install("Linux")
        self.assertEqual(
            (self.project / "flutter-call").read_text(), "build linux --release"
        )
        data = Path(self.environment["XDG_DATA_HOME"])
        desktop = data / "applications/ca.cleaver.flood.desktop"
        subprocess.run(["desktop-file-validate", str(desktop)], check=True)
        self.assertIn(
            f'Exec="{self.project}/build/linux/x64/release/bundle/flood"',
            desktop.read_text(),
        )
        self.assertEqual(
            (data / "icons/hicolor/scalable/apps/ca.cleaver.flood.svg").read_bytes(),
            (PROJECT / "assets/icons/flood.svg").read_bytes(),
        )

    def test_macos_installs_complete_bundle_and_removes_stale_files_on_update(self):
        self.install("Darwin")
        self.assertEqual(
            (self.project / "flutter-call").read_text(), "build macos --release"
        )
        app = Path(self.environment["FLOOD_APPLICATIONS_DIR"]) / "Flood.app"
        self.assertTrue(os.access(app / "Contents/MacOS/flood", os.X_OK))
        self.assertEqual(
            (app / "Contents/Resources/AppIcon.icns").read_bytes(), b"fixture icon"
        )
        self.assertTrue((app / "Contents/icon-link").is_symlink())
        stale = app / "Contents/old-framework"
        stale.write_text("obsolete")
        self.install("Darwin")
        self.assertFalse(stale.exists())


if __name__ == "__main__":
    unittest.main()
