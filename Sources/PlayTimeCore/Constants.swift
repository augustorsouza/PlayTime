import Foundation

let CONTENTS_XCPLAYGROUND_TEMPLATE =
    """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <playground version='5.0' target-platform='#{PLATFORM}'>
        <timeline fileName='timeline.xctimeline'/>
    </playground>
    """
let TMP_PATH_TEMPLATE = "/tmp/PlayTime/#{PLAYGROUND_FILE_NAME}.playground"
let IMPORT_TEMPLATE = "import #{FRAMEWORK}"
let CONTENTS_SWIFT_FILENAME = "Contents.swift"
let CONTENTS_XCPLAYGROUND_FILENAME = "contents.xcplayground"
