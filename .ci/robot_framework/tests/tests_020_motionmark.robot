*** Settings ***
Documentation       MotionMark automation benchmark suite for browser performance testing.

Library             SeleniumLibrary
Resource            variables.robot
Resource            keywords_common.robot

Suite Setup         Webdriver Remote Start
Suite Teardown      Webdriver Remote Stop
Test Timeout        10 minutes


*** Variables ***
${URL}                      https://browserbench.org/MotionMark1.2/
${RUN_BENCHMARK_BUTTON}     xpath=//*[@id="intro"]/div[2]/button
${TEST_AGAIN_BUTTON}
...    xpath=//button[contains(@onclick, 'benchmarkController.startBenchmark()') and contains(text(), 'Test Again')]


*** Test Cases ***
Run MotionMark And Validate Score
    [Documentation]    Loads MotionMark benchmark, runs it, waits for the score, and validates.
    [Tags]    test:retry(0)

    Wait Until Keyword Succeeds    18x    10s    Check Device Is IDLE

    Go To    ${URL}
    Wait Until Page Contains Element    ${RUN_BENCHMARK_BUTTON}
    Click Element    ${RUN_BENCHMARK_BUTTON}

    Capture Images Until Test Completion

    Wait Until Page Contains Element    ${TEST_AGAIN_BUTTON}    timeout=600s
    Capture Page Screenshot

    ${score}=    Get Global Score
    ${mapping}=    Get Test Name Score Mapping

    Log    MotionMark Score : ${score}
    Log    Name/Score Mapping: ${mapping}

    ${MOTIONMARK_MIN_SCORE}=    Get Machine Expectation
    ...    id=motionmark-min-score
    ...    machine=%{TEST_MACHINE}
    ...    wpeversion=%{TEST_WPEWEBKIT_VERSION}
    ...    type=number
    Should Be True    ${score} > ${MOTIONMARK_MIN_SCORE}


*** Keywords ***
Capture Images Until Test Completion
    [Documentation]    Captures a screenshot each time a new test section loads until the "Test Again" button appears
    ...    or the max iterations are reached.
    [Arguments]    ${max_iterations}=45

    VAR    ${index}=    1
    WHILE    ${index} <= ${max_iterations}
        Sleep    20s
        Capture Page Screenshot    motionmark_test_${index}.png
        ${index}=    Evaluate    ${index} + 1

        ${is_test_again_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${TEST_AGAIN_BUTTON}
        IF    ${is_test_again_visible}    BREAK
    END

Get Global Score
    [Documentation]    Returns the global MotionMark score from the results section.
    ${score}=    SeleniumLibrary.Get Text
    ...    xpath=//section[@id="results"]//div[@class="score-container"]//div[@class="score"]
    RETURN    ${score}

Get Test Names
    [Documentation]    Returns a list of test names from the results section.
    @{tests}=    Get WebElements
    ...    xpath=//table[@id="results-header"]/tbody/tr/td[not(contains(@class,"suites-separator"))]
    VAR    @{names}=    ${EMPTY}
    FOR    ${test}    IN    @{tests}
        ${name}=    SeleniumLibrary.Get Text    ${test}
        Append To List    ${names}    ${name}
    END
    RETURN    ${names}

Get Test Scores
    [Documentation]    Returns a list of per-test scores from the results section.
    @{scores}=    Get WebElements
    ...    xpath=//table[@id="results-score"]/tbody/tr/td[not(contains(@class,"suites-separator"))]
    VAR    @{values}=    ${EMPTY}
    FOR    ${score}    IN    @{scores}
        ${value}=    SeleniumLibrary.Get Text    ${score}
        Append To List    ${values}    ${value}
    END
    RETURN    ${values}

Get Test Name Score Mapping
    [Documentation]    Returns a dictionary mapping each test name to its score.
    ${names}=    Get Test Names
    ${scores}=    Get Test Scores
    ${mapping}=    Create Dictionary
    FOR    ${index}    IN RANGE    ${names.__len__()}
        ${name}=    Get From List    ${names}    ${index}
        ${score}=    Get From List    ${scores}    ${index}
        Set To Dictionary    ${mapping}    ${name}    ${score}
    END
    RETURN    ${mapping}
