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
