import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1366
    height: 768
    title: "Magic 6Ball"
    color: "#212121"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: introPageComponent
    }

    Component {
        id: introPageComponent
        IntroPage {}
    }

    Component {
        id: mainPageComponent
        MainPage {}
    }
}
