find_program(CLANG_TIDY NAMES clang-tidy)

if(CLANG_TIDY)
    list(APPEND CLANG_TIDY_OPTIONS -p ${CMAKE_BINARY_DIR})
    set(CMAKE_C_CLANG_TIDY ${CLANG_TIDY} ${CLANG_TIDY_OPTIONS})
    set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY} ${CLANG_TIDY_OPTIONS})
endif()

find_program(CPPCHECK NAMES cppcheck)

if(CPPCHECK)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/cppcheck)
    list(APPEND CPPCHECK_OPTIONS
        --cppcheck-build-dir=${CMAKE_BINARY_DIR}/cppcheck
        --enable=all
    )

    set(CMAKE_C_CPPCHECK ${CPPCHECK} ${CPPCHECK_OPTIONS})
    set(CMAKE_CXX_CPPCHECK ${CPPCHECK} ${CPPCHECK_OPTIONS})
endif()

if(MSVC)
    add_compile_options(
        /W4 /permissive-

        # Turn on useful warnings
        /w14242 # 'identfier': conversion from 'type1' to 'type1', possible loss of data
        /w14254 # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
        /w14287 # 'operator': unsigned/negative constant mismatch
        /we4289 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
        /w14296 # 'operator': expression is always 'boolean_value'
        /w14311 # 'variable': pointer truncation from 'type1' to 'type2'
        /w14545 # expression before comma evaluates to a function which is missing an argument list
        /w14546 # function call before comma missing argument list
        /w14547 # 'operator': operator before comma has no effect; expected operator with side-effect
        /w14549 # 'operator': operator before comma has no effect; did you intend 'operator'?
        /w14555 # expression has no effect; expected expression with side-effect
        /w14619 # pragma warning: there is no warning number 'number'
        /w14640 # Enable warning on thread unsafe static member initialization
        /w14826 # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
        /w14905 # wide string literal cast to 'LPSTR'
        /w14906 # string literal cast to 'LPWSTR'
        /w14928 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied

        # Turn off warnings of external libraries
        /external:anglebrackets /external:W0 /analyze:external-

        # Treat warnings as errors
        /wd4263 # 'function': member function does not override any base class virtual member function
        /wd4265 # 'classname': class has virtual functions, but destructor is not virtual instances of this class may not be destructed correctly
    )
else()
    add_compile_options(
        -Wall -Wextra -pedantic

        # Turn on useful warnings
        -Wold-style-cast # warn for c-style casts
        -Wcast-align # warn for potential performance problem casts
        -Wunused # warn on anything being unused
        -Wpedantic # warn if non-standard C++ is used
        -Wconversion # warn on type conversions that may lose data
        -Wsign-conversion # warn on sign conversions
        -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
        $<$<CXX_COMPILER_ID:GNU>:-Wduplicated-cond> # warn if if / else chain has duplicated conditions
        $<$<CXX_COMPILER_ID:GNU>:-Wduplicated-branches> # warn if if / else branches have duplicated code
        $<$<CXX_COMPILER_ID:GNU>:-Wlogical-op> # warn about logical operations being used where bitwise were probably wanted
        $<$<CXX_COMPILER_ID:GNU>:-Wuseless-cast> # warn if you perform a cast to the same type
        -Wdouble-promotion # warn if float is implicitly promoted to double
        -Wformat=2 # warn on security issues around functions that format output(i.e., printf)
        -Wimplicit-fallthrough # warn when case statements fall-through.(Included with -Wextra in GCC, not in clang)

        # Treat warnings as errors
        -Werror=non-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps catch hard to track down memory errors
        -Werror=overloaded-virtual # warn if you overload(not override) a virtual function
        -Werror=null-dereference # warn if a null dereference is detected

        # Ignore warnings
        -Wno-gnu-zero-variadic-macro-arguments
    )
endif()
