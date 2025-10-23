# KEEP plugin Android classes 
-keep class com.hiennv.flutter_callkit_incoming.** { *; }

# Keep Gson classes & TypeToken if plugin uses Gson
-keep class com.google.gson.** { *; }
-keepclassmembers class com.google.gson.reflect.TypeToken { *; }