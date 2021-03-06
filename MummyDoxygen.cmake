IF(NOT DOXYGEN_EXECUTABLE)
  FIND_PACKAGE(Doxygen)
ENDIF(NOT DOXYGEN_EXECUTABLE)

SET(Mummy_BUILD_DOCUMENTATION_DEFAULT OFF)
IF(DOXYGEN_EXECUTABLE)
IF(Mummy_BUILD_COMPONENT_MUMMY)
  SET(Mummy_BUILD_DOCUMENTATION_DEFAULT ON)
ENDIF(Mummy_BUILD_COMPONENT_MUMMY)
ENDIF(DOXYGEN_EXECUTABLE)

OPTION(Mummy_BUILD_DOCUMENTATION "Build mummy doxygen documentation" ${Mummy_BUILD_DOCUMENTATION_DEFAULT})

IF(Mummy_BUILD_DOCUMENTATION)
  OPTION(Mummy_DOXYGEN_SHORT_NAMES "Build mummy doxygen output with short file names" OFF)
  MARK_AS_ADVANCED(Mummy_DOXYGEN_SHORT_NAMES)

  # Force it to be exactly "YES" or "NO"
  IF(Mummy_DOXYGEN_SHORT_NAMES)
    SET(Mummy_DOXYGEN_SHORT_NAMES YES)
  ELSE(Mummy_DOXYGEN_SHORT_NAMES)
    SET(Mummy_DOXYGEN_SHORT_NAMES NO)
  ENDIF(Mummy_DOXYGEN_SHORT_NAMES)

  SET(HAVE_DOT_YESNO NO)
  IF(DOT)
    SET(HAVE_DOT_YESNO YES)
    IF(NOT DOT_PATH)
      GET_FILENAME_COMPONENT(DOT_PATH ${DOT} PATH)
    ENDIF(NOT DOT_PATH)
  ENDIF(DOT)

  CONFIGURE_FILE(
    ${CMAKE_CURRENT_SOURCE_DIR}/MummyDoxygen.doxyfile.in
    ${CMAKE_CURRENT_BINARY_DIR}/doxygen/doxyfile
    )

  ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/doxygen/html/index.html
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/doxygen/doxyfile
    DEPENDS
      ${CMAKE_CURRENT_BINARY_DIR}/doxygen/doxyfile
      ${CMAKE_CURRENT_LIST_FILE}
      ${CMAKE_CURRENT_SOURCE_DIR}/MummyApplication.cxx
    )

  ADD_CUSTOM_TARGET(mummyDoxygen ALL
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/doxygen/html/index.html
    )
ENDIF(Mummy_BUILD_DOCUMENTATION)
