file(GLOB HTTPLIB_CORPUS corpus/*)
add_executable(httplib-test-fuzz
    server_fuzzer.cc
    standalone_fuzz_target_runner.cpp
)
target_link_libraries(httplib-test-fuzz PRIVATE httplib)
add_test(
    NAME httplib-test-fuzz
    COMMAND httplib-test-fuzz ${HTTPLIB_CORPUS}
)

if(MSVC)
    cmake_path(GET CMAKE_CXX_COMPILER PARENT_PATH VS_PATH)
    set_tests_properties(httplib-test-fuzz
        PROPERTIES ENVIRONMENT PATH=${VS_PATH}
    )
endif()
