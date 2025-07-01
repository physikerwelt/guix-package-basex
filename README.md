# guix-package-basex

## 2025-7-1

Getting familiar with guix

* maven 3.9.0 seems to be incompatible with jdk@24
Solution: `guix install openjdk@17`

Final setup
```
debian@debian:~/basex$ mvn --version
Apache Maven 3.9.0 (guix_build)
Maven home: /gnu/store/0wzwx9fir0pb5w2x1kmpvjyfkv0c7kgm-maven-3.9.0
Java version: 17.0.10, vendor: N/A, runtime: /gnu/store/59wy373xv8hi4fq4m3qqwrfm91fkqs8f-openjdk-17.0.10
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "6.1.0-35-arm64", arch: "aarch64", family: "unix"
```
It still does not work, however, when using /usr/bin/mvn installed by apt-get install maven
it seems to work

```
debian@debian:~/basex$ mvn compile -DskipTests
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ basex-api ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.13.0:compile (default-compile) @ basex-api ---
[INFO] Recompiling the module because of changed dependency.
[INFO] Compiling 116 source files with javac [debug target 17] to target/classes
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for BaseX 12.0:
[INFO] 
[INFO] BaseX .............................................. SUCCESS [  0.001 s]
[INFO] BaseX Core ......................................... SUCCESS [  5.621 s]
[INFO] BaseX API .......................................... SUCCESS [  6.002 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  11.720 s
[INFO] Finished at: 2025-07-01T06:55:41-07:00
[INFO] ------------------------------------------------------------------------
```

Here the exact versions are
```
debian@debian:~/basex$ mvn --version
Apache Maven 3.8.7
Maven home: /usr/share/maven
Java version: 17.0.15, vendor: Debian, runtime: /usr/lib/jvm/java-17-openjdk-arm64
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "6.1.0-35-arm64", arch: "aarch64", family: "unix"`
```
Try again
```
sudo apt-get remove maven openjdk-17-jdk
debian@debian:~/basex$ guix install openjdk@17 maven
hint: Consider installing the `glibc-locales' package and defining `GUIX_LOCPATH', along these lines:

     guix install glibc-locales
     export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"

See the "Application Setup" section in the manual, for more info.

The following packages will be installed:
   maven   3.9.0
   openjdk 17.0.10

debian@debian:~/basex$ mvn --version
Apache Maven 3.9.0 (guix_build)
Maven home: /gnu/store/0wzwx9fir0pb5w2x1kmpvjyfkv0c7kgm-maven-3.9.0
Java version: 17.0.10, vendor: N/A, runtime: /gnu/store/59wy373xv8hi4fq4m3qqwrfm91fkqs8f-openjdk-17.0.10
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "6.1.0-35-arm64", arch: "aarch64", family: "unix"
debian@debian:~/basex$ mvn compile -DskipTests
[ERROR] Error executing Maven.
[ERROR] java.lang.IllegalStateException: Unable to load cache item
[ERROR] Caused by: Unable to load cache item
[ERROR] Caused by: Could not initialize class net.sf.cglib.core.MethodWrapper
[ERROR] Caused by: Exception net.sf.cglib.core.CodeGenerationException: java.lang.reflect.InaccessibleObjectException-->Unable to make protected final java.lang.Class java.lang.ClassLoader.defineClass(java.lang.String,byte[],int,int,java.security.ProtectionDomain) throws java.lang.ClassFormatError accessible: module java.base does not "opens java.lang" to unnamed module @57536d79 [in thread "main"]
```
fixing that via
```
export MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED"
```
reveals that openjdk is a jre not a jdk
```
INFO] Reactor Summary for BaseX 12.0:
[INFO] 
[INFO] BaseX .............................................. SUCCESS [  0.001 s]
[INFO] BaseX Core ......................................... FAILURE [  0.471 s]
[INFO] BaseX API .......................................... SKIPPED
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.584 s
[INFO] Finished at: 2025-07-01T07:05:13-07:00
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.13.0:compile (default-compile) on project basex: Compilation failure
[ERROR] No compiler is provided in this environment. Perhaps you are running on a JRE rather than a JDK?
[ERROR] 
[ERROR
```
There is no jdk
```
 javac -v
-bash: javac: command not found
```
