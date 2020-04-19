import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(my_copy_tweakTests.allTests),
    ]
}
#endif
