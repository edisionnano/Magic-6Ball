import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: introPage
    width: 1366
    height: 768
    anchors.fill: parent
    property alias initialMessage: inputField.text
    property var randomMessages: []

    Component.onCompleted: {
        randomMessages = chatDb.getRandomFirstMessages();
    }

    Rectangle {
        anchors.fill: parent
        color: "#212121"

        ColumnLayout {
            width: parent.width
            anchors.top: parent.top

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "#303030"

                Image {
                    source: "qrc:/icons/logo.svg"
                    height: 40
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    mipmap: true
                }
            }
        }

        ColumnLayout {
            width: parent.width * 0.6
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "How can I help you?"
                color: "#ececec"
                font.pixelSize: 24
                font.weight: 600
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "#303030"
                radius: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    anchors.margins: 10

                    TextArea {
                        id: inputField
                        Layout.fillWidth: true
                        placeholderText: "Ask the magic ball!"
                        placeholderTextColor: "#9b9b9b"
                        color: "#ececec"
                        font.pixelSize: 15
                        focus: true
                        background: Rectangle {
                            color: "#303030"
                            radius: 8
                        }
                        Keys.onTabPressed: {
                            ;
                        }
                        Component.onCompleted: {
                            Qt.callLater(() => inputField.forceActiveFocus());
                        }
                        Keys.onReturnPressed: function(event) {
                            if (inputField.text.trim() !== "") {
                                let newChatId = chatDb.createNewChat();
                                stackView.push(mainPageComponent, { firstMessage: inputField.text.trim(), chatId: newChatId });
                            }
                        }
                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Up) {
                                inputField.cursorPosition = 0;
                            }
                            else if (event.key === Qt.Key_Down) {
                                inputField.cursorPosition = inputField.text.length;
                            }
                        }
                    }

                    Image {
                        source: "qrc:/icons/arrow.svg"
                        opacity: inputField.text.trim() === "" ? 0.5 : 1.0
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: if (inputField.text.trim() !== "") {
                                let newChatId = chatDb.createNewChat();
                                stackView.push(mainPageComponent, { firstMessage: inputField.text.trim(), chatId: newChatId });
                            }
                            cursorShape: inputField.text.trim() === "" ? Qt.ArrowCursor : Qt.PointingHandCursor
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 10
                visible: randomMessages.length > 0
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true

                Text {
                    text: "Other people asked:"
                    color: "#ececec"
                    font.pixelSize: 18
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    width: parent.width * 0.95
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0

                    Repeater {
                        model: randomMessages
                        delegate: Column {
                            width: parent.width

                            Text {
                                text: modelData
                                color: "#ececec"
                                font.pixelSize: 16
                                wrapMode: Text.Wrap
                                padding: 10
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: "#9b9b9b"
                                opacity: 0.2
                                anchors.horizontalCenter: parent.horizontalCenter
                                visible: index !== (randomMessages.length - 1)
                            }
                        }
                    }
                }
            }
        }

        ColumnLayout {
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            Text {
                Layout.fillWidth: true
                text: "The magic ball cannot predict the future and it is not actually magic."
                color: "#a4a9ab"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
