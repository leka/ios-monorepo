## What's Changed
* :bookmark: (release): Bump to v1.3.0 by @ladislas in https://github.com/leka/LekaOS/pull/1211
* :hammer: (cmake): FirmwareKit - depend on os_version file by @ladislas in https://github.com/leka/LekaOS/pull/1231
* 🚸 (ble): Add isConnected by @YannLocatelli in https://github.com/leka/LekaOS/pull/1219
* ♻️ (rc): Separate timeout: inner state and state transition by @YannLocatelli in https://github.com/leka/LekaOS/pull/1238
* 🚚 (behavior): Rename misleading bleConnection tests by @YannLocatelli in https://github.com/leka/LekaOS/pull/1221
* 🚚 (sm): Rename onFileExchange{Start/End} by {start/stop}FileExchange by @YannLocatelli in https://github.com/leka/LekaOS/pull/1222
* ♻️ (behaviorkit): Separate bleConnection into bleConnectionWithoutVideo and bleConnectionWithVideo by @YannLocatelli in https://github.com/leka/LekaOS/pull/1251
* ✨ (rc): Add DeepSleep state by @YannLocatelli in https://github.com/leka/LekaOS/pull/1239
* ✨ (eventqueue): Add cancelLastCall by @YannLocatelli in https://github.com/leka/LekaOS/pull/1252
* ✅ Fix uninteresting mock function call by @YannLocatelli in https://github.com/leka/LekaOS/pull/1253
* mmyster/feature/add touch sensor kit by @MMyster in https://github.com/leka/LekaOS/pull/830
* mmyster/feature/add lk touch sensor kit by @MMyster in https://github.com/leka/LekaOS/pull/926
* ♻️ Use std::function instead of mbed::Callback by @YannLocatelli in https://github.com/leka/LekaOS/pull/1255
* :pushpin: (mbed): Pin to mbed-os@master+fixes+gcc-11-support by @ladislas in https://github.com/leka/LekaOS/pull/1261
* 🔥 (libs): Remove lib InvestigationDay by @YannLocatelli in https://github.com/leka/LekaOS/pull/1263
* ✨ (Firmware) - Add Format Factory by @YannLocatelli in https://github.com/leka/LekaOS/pull/1259
* 👷 (release): Check version is correct by @YannLocatelli in https://github.com/leka/LekaOS/pull/1260
* ✨ (config): Config with multiple values by @YannLocatelli in https://github.com/leka/LekaOS/pull/1258
* hugo/feature/Create CoreInterruptIn by @HPezz in https://github.com/leka/LekaOS/pull/1262
* ladislas/feature/generate directory strcture as namespace by @ladislas in https://github.com/leka/LekaOS/pull/1266
* :white_check_mark: (jpeg): Improve CoreJPEG(+ModeDMA) coverage by @YannLocatelli in https://github.com/leka/LekaOS/pull/1267
* ✅ (file): Refactor Unit Tests by @YannLocatelli in https://github.com/leka/LekaOS/pull/1275
* ♻️ (video): Forward declare CGColor and CGPixel struct by @YannLocatelli in https://github.com/leka/LekaOS/pull/1271
* :recycle: (video): Set CGGraphics with CGColor+CGPoint+CGPixel+Character+FilledRectangle by @YannLocatelli in https://github.com/leka/LekaOS/pull/1274
* ♻️ (video): Videokit use EventLoop by @YannLocatelli in https://github.com/leka/LekaOS/pull/1268
* ✨ (rc): Get Magic card via BLE by @YannLocatelli in https://github.com/leka/LekaOS/pull/1273
* ✨ (rc): Set custom robot name by @YannLocatelli in https://github.com/leka/LekaOS/pull/1256
* hugo/feature/Get imu data on interrupt by @HPezz in https://github.com/leka/LekaOS/pull/1257
* :sparkles: (makefile): Build firmware + os in parallel by @ladislas in https://github.com/leka/LekaOS/pull/1269
* :fire: (IMUKit ft): Comment failing tests by @HPezz in https://github.com/leka/LekaOS/pull/1282
* ♻️ (filemanager): Refactor UTs by @YannLocatelli in https://github.com/leka/LekaOS/pull/1281
* ladislas/feature/ahrs fusion by @ladislas in https://github.com/leka/LekaOS/pull/1245
* :wrench: (clang-format): Update ignored files, directories by @ladislas in https://github.com/leka/LekaOS/pull/1290
* ladislas/feature/lsm6dsox check callback exists by @ladislas in https://github.com/leka/LekaOS/pull/1291
* ladislas/feature/replace mahony with new fusion by @ladislas in https://github.com/leka/LekaOS/pull/1287
* Yann/feature/filemanagerkit/add exists by @YannLocatelli in https://github.com/leka/LekaOS/pull/1163
* ladislas/feature/lsm6dsox data timestamp by @ladislas in https://github.com/leka/LekaOS/pull/1289
* :arrow_up: (IMUKit): Bump Fusion to v1.0.9 by @ladislas in https://github.com/leka/LekaOS/pull/1293
* :fire: (libs): Remove PrettyPrinter, as not used anymore by @ladislas in https://github.com/leka/LekaOS/pull/1302
* ladislas/feature/ci cleanup analysis workflows by @ladislas in https://github.com/leka/LekaOS/pull/1304
* ladislas/feature/ci add workflow toolchain upgrade by @ladislas in https://github.com/leka/LekaOS/pull/1305
* ladislas/bugfix/ci workflows fix typo licence by @ladislas in https://github.com/leka/LekaOS/pull/1307
* :wrench: (tools): Python - add mbed_requirements.txt file by @ladislas in https://github.com/leka/LekaOS/pull/1316
* hugo/feature/Update MotionKit Rotation to Fusion by @HPezz in https://github.com/leka/LekaOS/pull/1314
* 🐛 (RC): Move onMagicCardAvailable at end of onTagActivated by @YannLocatelli in https://github.com/leka/LekaOS/pull/1310
* :recycle: (ColorKit): Add const to conversion local variables by @ladislas in https://github.com/leka/LekaOS/pull/1313
* ✨ (spikes): Add ActivityKit spike by @YannLocatelli in https://github.com/leka/LekaOS/pull/1320
* ✅ (MotionKit): Remove log_debug in UTs of RotationControl by @YannLocatelli in https://github.com/leka/LekaOS/pull/1321
* 🚸 (rc): Add autonomous activities timeout by @YannLocatelli in https://github.com/leka/LekaOS/pull/1322
* :fire: (State Machine): Remove DeepSleeping SM state by @HPezz in https://github.com/leka/LekaOS/pull/1323


**Full Changelog**: https://github.com/leka/LekaOS/compare/v1.3.0...v1.4.0