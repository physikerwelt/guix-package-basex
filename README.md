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
This can be solved by running `guix package -i openjdk@17:jdk` with that one can build basex
```
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for BaseX 12.0:
[INFO] 
[INFO] BaseX .............................................. SUCCESS [  0.001 s]
[INFO] BaseX Core ......................................... SUCCESS [ 14.649 s]
[INFO] BaseX API .......................................... SUCCESS [  0.669 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  15.432 s
[INFO] Finished at: 2025-07-01T12:49:42-07:00
[INFO] ------------------------------------------------------------------------
```

## 2025-07-03

Add minimal docker file (without guix)
```
$ ./getBasex.sh                              
--2025-07-04 02:02:52--  https://files.basex.org/releases/12.0/BaseX120.zip
Resolving files.basex.org (files.basex.org)... 185.221.106.187
Connecting to files.basex.org (files.basex.org)|185.221.106.187|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 11996806 (11M) [application/zip]
Saving to: ‘BaseX120.zip.1’

BaseX120.zip.1                                  100%[=====================================================================================================>]  11.44M  17.0MB/s    in 0.7s    

2025-07-04 02:02:53 (17.0 MB/s) - ‘BaseX120.zip.1’ saved [11996806/11996806]

Archive:  BaseX120.zip
replace basex/.basexhome? [y]es, [n]o, [A]ll, [N]one, [r]ename: A
 extracting: basex/.basexhome   
...
  inflating: basex/webapp/WEB-INF/web.xml  
$docker build . -t basex                   
[+] Building 0.9s (8/8) FINISHED                                                                                                                                         docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                                                                     0.0s
 => => transferring dockerfile: 191B                                                                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/eclipse-temurin:21                                                                                                                    0.8s
 => [internal] load .dockerignore                                                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                                                          0.0s
 => [1/3] FROM docker.io/library/eclipse-temurin:21@sha256:1c37779fe2f338d42a7bc8ac439920ef2bf7cebb7deb0970f5733219b17e9868                                                              0.0s
 => => resolve docker.io/library/eclipse-temurin:21@sha256:1c37779fe2f338d42a7bc8ac439920ef2bf7cebb7deb0970f5733219b17e9868                                                              0.0s
 => [internal] load build context                                                                                                                                                        0.0s
 => => transferring context: 8.68kB                                                                                                                                                      0.0s
 => CACHED [2/3] WORKDIR /basex                                                                                                                                                          0.0s
 => CACHED [3/3] COPY ./basex /basex                                                                                                                                                     0.0s
 => exporting to image                                                                                                                                                                   0.0s
 => => exporting layers                                                                                                                                                                  0.0s
 => => exporting manifest sha256:2bee8d98d531a278eeb78970c4320ea0141b864cb4b5e3214abb951dbe4a5a25                                                                                        0.0s
 => => exporting config sha256:87dae0f78570d6cb696cfc63b141b7a56380551ea6011d8027376ccf67f93d9a                                                                                          0.0s
 => => exporting attestation manifest sha256:279eeefc0f6b7217ae631a1d01c77b13f0a624b1d204756990d918a96056065f                                                                            0.0s
 => => exporting manifest list sha256:5bfdbbf8afb26e7342336e028aeccce3ff276540c2ff0b8961273a0a39d3b8a8                                                                                   0.0s
 => => naming to docker.io/library/basex:latest                                                                                                                                          0.0s
 => => unpacking to docker.io/library/basex:latest                                                                                                                                       0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/1oogcscxdpamiwikzrcnks9xb

What's next:
    View a summary of image vulnerabilities and recommendations → docker scout quickview 
$ docker run -p 8080:8080 -it basex  
/basex/.basex: writing new configuration file.
BaseX 12.0 [HTTP Server]
[main] INFO org.eclipse.jetty.server.Server - jetty-12.0.22; built: 2025-06-02T15:25:31.946Z; git: 335c9ab44a5591f0ea941bf350e139b8c4f5537c; jvm 21.0.7+6-LTS
[main] INFO org.eclipse.jetty.ee9.webapp.StandardDescriptorProcessor - NO JSP Support for /, did not find org.eclipse.jetty.ee9.jsp.JettyJspServlet
[main] INFO org.eclipse.jetty.session.DefaultSessionIdManager - Session workerName=node0
Server was started (port: 1984).
[main] INFO org.eclipse.jetty.server.handler.ContextHandler - Started oeje9n.ContextHandler$CoreContextHandler@2c4d1ac{BaseX: The XML Database and XQuery Processor,/,b=file:///basex/webapp/,a=AVAILABLE,h=oeje9n.ContextHandler$CoreContextHandler$CoreToNestedHandler@7f0d96f2{STARTED}}
[main] INFO org.eclipse.jetty.server.AbstractConnector - Started ServerConnector@6b88ca8c{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
[main] INFO org.eclipse.jetty.server.Server - Started oejs.Server@9d5509a{STARTING}[12.0.22,sto=0] @441ms
HTTP STOP Server was started (port: 8081).
HTTP Server was started (port: 8080).
Password: 

```
enter password
