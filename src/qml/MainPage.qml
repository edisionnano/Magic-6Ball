import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: mainPage
    width: 1366
    height: 768
    anchors.fill: parent
    property string firstMessage: ""
    property string currentAnswer: ""
    property string lastUserMessage: ""
    property int currentIndex: 0
    property int chatId
    property bool editMode: false

    Component.onCompleted: {
        if (firstMessage !== "") {
            chatModel.append({ sender: "user", message: firstMessage });
            chatDb.saveMessage(chatId, "user", firstMessage);
            lastUserMessage = firstMessage;
            showThinking();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        // spacing: 0

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

        ListView {
            id: chatView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: chatModel
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            delegate: Item {
                width: parent.width
                height: childrenRect.height + 10

                Row {
                    anchors.left: model.sender === "8ball" ? parent.left : undefined
                    anchors.right: model.sender === "user" ? parent.right : undefined
                    spacing: 5

                    Image {
                        source: model.sender === "user" ? "" : "qrc:/icons/8ball.svg"
                        width: 30
                        height: 30
                        visible: true
                        mipmap: true
                    }

                    Rectangle {
                        width: Math.min(mainPage.width * 0.5, messageText.implicitWidth + 30)
                        height: messageText.implicitHeight + 20
                        color: model.sender === "user" ? "#ececec" : (model.thinking ? "transparent" : "#303030")
                        anchors.margins: 10
                        opacity: model.thinking ? 0.6 : 1.0
                        radius: 15

                        Rectangle {
                            width: 15; height: 15
                            color: parent.color
                            visible: model.sender === "8ball"
                            anchors.top: parent.top
                            anchors.left: parent.left
                        }

                        Rectangle {
                            width: 15; height: 15
                            color: parent.color
                            visible: model.sender === "user"
                            anchors.top: parent.top
                            anchors.right: parent.right
                        }

                        Image {
                            id: profilePicture
                            source: model.sender === "8ball" ? "qrc:/icons/tail_8ball.svg" : "qrc:/icons/tail.svg"
                            width: 15
                            height: 10
                            visible: !(model.thinking)
                            anchors.top: parent.top
                            anchors.left: model.sender === "8ball" ? parent.left : undefined
                            anchors.right: model.sender === "user" ? parent.right : undefined
                            anchors.leftMargin: -6
                            anchors.rightMargin: -6
                            mipmap: true
                        }

                        Text {
                            id: messageText
                            text: model.message
                            color: model.sender === "user" ? "black" : (model.thinking ? "#cccccc" : "#ececec")
                            wrapMode: Text.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.fill: model.thinking ? undefined : parent
                            anchors.horizontalCenter: model.thinking ? parent.horizontalCenter : undefined
                            anchors.top: model.thinking ? profilePicture.top : undefined
                            anchors.topMargin: model.thinking ? profilePicture.height / 2 : undefined
                            anchors.margins: 10
                            SequentialAnimation {
                                id: shimmerAnimation
                                running: model.thinking
                                loops: Animation.Infinite
                                PropertyAnimation { target: messageText; property: "opacity"; to: 1.0; duration: 300 }
                                PropertyAnimation { target: messageText; property: "opacity"; to: 0.3; duration: 300 }
                            }
                        }
                    }

                    Image {
                        source: model.sender === "user" ? "qrc:/icons/user.svg" : ""
                        width: 30
                        height: 30
                        visible: true
                        mipmap: true
                    }
                }
            }
            clip: true
            ScrollIndicator.vertical: ScrollIndicator {
                parent: chatView
            }
            onCountChanged: chatView.contentY = chatView.contentHeight;
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
                    enabled: !chatModel.get(chatModel.count - 1)?.thinking
                    Keys.onReturnPressed: sendMessage()
                    Keys.onPressed: function(event) {
                        var keyEvent = event;
                        if (keyEvent.modifiers & Qt.ControlModifier && keyEvent.modifiers & Qt.ShiftModifier && keyEvent.nativeScanCode === 27) { // R
                            clearChat();
                        }
                        else if (keyEvent.modifiers & Qt.ControlModifier && keyEvent.modifiers & Qt.ShiftModifier && keyEvent.nativeScanCode === 57) { // N
                            startNewChat();
                        }
                        else if (keyEvent.key === Qt.Key_Up) {
                            if (inputField.text.trim() === "") {
                                if (lastUserMessage !== "") {
                                    inputField.text = lastUserMessage;
                                    inputField.cursorPosition = lastUserMessage.length;
                                    editMode = true;
                                }
                            } else {
                                inputField.cursorPosition = 0;
                            }
                        }
                        else if (keyEvent.key === Qt.Key_Down) {
                            inputField.cursorPosition = inputField.text.length;
                        }
                        else if (keyEvent.key === Qt.Key_Escape) {
                            inputField.text = "";
                            editMode = false;
                        }
                    }
                }

                Image {
                    source: editMode ? "qrc:/icons/pencil.svg" : "qrc:/icons/arrow.svg"
                    opacity: inputField.text.trim() === "" ? 0.5 : 1.0
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: sendMessage()
                        cursorShape: inputField.text.trim() === "" ? Qt.ArrowCursor : Qt.PointingHandCursor
                    }
                }
            }
        }
        Text {
            Layout.fillWidth: true
            text: "The magic ball cannot predict the future and it is not actually magic."
            color: "#a4a9ab"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
        }
    }

    ListModel {
        id: chatModel
    }

    function sendMessage() {
        let messages = inputField.text.split('\n');
        if (!Array.isArray(messages) || messages.length === 0) return;

        messages.forEach(trimmedText => {
            trimmedText = trimmedText.trim();
            if (trimmedText === "") return;
            else if (trimmedText === "!clear") {
                clearChat();
            }
            else if (trimmedText === "!new") {
                startNewChat();
            }
            else if (trimmedText.startsWith("!add ")) {
                let newAnswer = trimmedText.substring(5);
                answerProvider.addAnswer(newAnswer);
                chatModel.append({ sender: "8ball", message: "Answer added: " + newAnswer });
            }
            else {
                if (lastUserMessage !== "" && editMode) {
                    chatModel.remove(chatModel.count - 1);
                    chatModel.remove(chatModel.count - 1);
                }
                chatDb.saveMessage(chatId, "user", trimmedText);
                chatModel.append({ sender: "user", message: trimmedText });
                lastUserMessage = trimmedText;
                showThinking();
            }
        });

        inputField.text = "";
    }

    function showThinking() {
        chatModel.append({ sender: "8ball", message: "Let me think about it...", thinking: true });
        inputField.enabled = false;
        startTimer();
    }

    Timer {
        id: answerTimer
        interval: 1500
        onTriggered: revealAnswer()
    }

    function startTimer() {
        answerTimer.start();
    }

    Timer {
        id: revealTimer
        interval: 50
        repeat: false
        running: false
        onTriggered: {
            graduallyRevealAnswer();
        }
    }

    function clearChat() {
        lastUserMessage = ""
        chatView.model = null;
        chatModel.clear();
        chatView.model = chatModel;
    }

    function startNewChat() {
        clearChat();
        stackView.pop()
        stackView.replace(introPageComponent, StackView.PopTransition);
    }

    function loadAnswers() {
        let answerFile = "file:///" + Qt.application.arguments[0].replace(/\/[^/]+$/, "/answers.txt");
        let xhr = new XMLHttpRequest();
        xhr.open("GET", answerFile, false);
        xhr.send(null);
        return xhr.responseText.split("\n").filter(line => line.trim() !== "");
    }

    function revealAnswer() {
        let answers = answerProvider.loadAnswers();
        let answer = answers[Math.floor(Math.random() * answers.length)];

        chatModel.set(chatModel.count - 1, { sender: "8ball", message: "", thinking: false });
        chatDb.saveMessage(chatId, "8ball", answer);
        currentAnswer = answer;
        currentIndex = 0;
        graduallyRevealAnswer();
    }

    function graduallyRevealAnswer() {
        if (currentIndex < currentAnswer.length) {
            chatModel.set(chatModel.count - 1, { sender: "8ball", message: currentAnswer.substring(0, currentIndex + 1) + "⬤", thinking: false });
            currentIndex++;
            revealTimer.start();
        } else {
            chatModel.set(chatModel.count - 1, { sender: "8ball", message: currentAnswer, thinking: false });
            inputField.enabled = true;
        }
        Qt.callLater(() => chatView.positionViewAtEnd());
    }
}
