# Install script for directory: /Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/llvm-3.1.src

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "Release")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/llvm-3.1.src/include/" FILES_MATCHING REGEX "/[^/]*\\.def$" REGEX "/[^/]*\\.h$" REGEX "/[^/]*\\.td$" REGEX "/[^/]*\\.inc$" REGEX "/license\\.txt$" REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/include/" FILES_MATCHING REGEX "/[^/]*\\.def$" REGEX "/[^/]*\\.h$" REGEX "/[^/]*\\.gen$" REGEX "/[^/]*\\.inc$" REGEX "/cmakefiles$" EXCLUDE REGEX "/\\.svn$" EXCLUDE)
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/lib/Support/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/lib/TableGen/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/TableGen/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/include/llvm/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/lib/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/FileCheck/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/FileUpdate/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/count/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/not/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/llvm-lit/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/yaml-bench/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/projects/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/tools/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/runtime/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/examples/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/test/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/utils/unittest/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/unittests/cmake_install.cmake")
  INCLUDE("/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/cmake/modules/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

IF(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
ELSE(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
ENDIF(CMAKE_INSTALL_COMPONENT)

FILE(WRITE "/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/${CMAKE_INSTALL_MANIFEST}" "")
FOREACH(file ${CMAKE_INSTALL_MANIFEST_FILES})
  FILE(APPEND "/Users/lipa/fractalstream/external/FractalStreamCompiler/external/llvm/${CMAKE_INSTALL_MANIFEST}" "${file}\n")
ENDFOREACH(file)
