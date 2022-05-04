
Auto Route 
    - When noticing this error: Found 1 declared outputs which already exist on disk. This is likely because the`.dart_tool/build` folder was deleted, or you are submitting generated files to your source repository.
    [SEVERE] Conflicting outputs were detected and the build is unable to prompt for permission to remove them. These outputs must be removed manually or the build can be run with `--delete-conflicting-outputs`. The outputs are: lib/app_route/AppRouting.gr.dart
        -  Delete the *.gr.dart file and re run build runner to generate the auto router
    - to generate app router using auto route: flutter packages pub run build_runner build
