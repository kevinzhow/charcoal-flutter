# Visual golden baselines

`visual_regression_test.dart` fixes widget behavior to `TargetPlatform.linux`
and uses Flutter's Ahem test font. Pixel rasterization still differs by host
operating system, so macOS and Linux keep separate, exact baselines.

Update only the directory for the host that renders the test:

```sh
fvm flutter test test/visual_regression_test.dart --update-goldens
```

Do not copy images between host directories or relax the pixel comparator.
GitHub Actions validates the Linux baselines on its Linux runner.
