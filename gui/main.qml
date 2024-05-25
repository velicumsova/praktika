import QtQuick 2.15
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 700
    height: 500
    color: Qt.rgba(0.15, 0.15, 0.15, 1)
    title: "Распознавание погоды и растений на изображениях"

    Rectangle {
        anchors.fill: parent
        anchors.margins: 25
        color: Qt.rgba(0.2, 0.2, 0.2, 1)
        radius: 15
    
        RowLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.margins: 25

            Item {
                id: previewArea
                Layout.fillWidth: true
                Layout.fillHeight: true

                Image {
                    id: previewImage
                    anchors.centerIn: parent
                    width: parent.width - 50
                    height: parent.height - 50
                    fillMode: Image.PreserveAspectFit

                    Behavior on scale {
                        NumberAnimation { 
                            duration: 100
                            easing.type: Easing.OutQuart
                        }
                    }

                    source: "assets/img_icon.png"

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        hoverEnabled: true

                        onEntered: parent.scale = 1.1
                        onExited: parent.scale = 1.0
                        onPressed: parent.scale = 0.7

                        onClicked: fileDialog.visible = true
                    }
                }
            }

            ColumnLayout {
                id: settingsArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15
                clip: true

                Button {
                    id: fileSelectButton
                    Layout.alignment: Qt.AlignHCenter
                    text: "Распознать"

                    Behavior on scale {
                        NumberAnimation { 
                            duration: 100
                            easing.type: Easing.OutQuart
                        }
                    }

                    background: Rectangle {
                        anchors.fill: parent
                        color: Qt.rgba(0.75, 0.75, 0.75, 1)
                        radius: 10

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton
                            hoverEnabled: true

                            onEntered: fileSelectButton.scale = 1.1
                            onExited: fileSelectButton.scale = 1.0
                            onPressed: fileSelectButton.scale = 0.7

                            onClicked: predResult.text = net.predict(fileDialog.fileUrl)
                        }
                    }
                }

                Text {
                    id: predResult
                    Layout.alignment: Qt.AlignHCenter
                    color: Qt.rgba(0.75, 0.75, 0.75, 1)
                    font.family: "Arial"
                    font.pixelSize: 12
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home

        onAccepted: {
            predResult.text = ""
            previewImage.source = fileUrl
        }
    }
}
