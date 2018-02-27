import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtWebSockets 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

        WebSocket {
            id: secureWebSocket
            url: "wss://www.realto.ch/websocket"
            property var last_message
            onTextMessageReceived: {
                messageBox.text = messageBox.text + "\nReceived secure message: " + message
                last_message=JSON.parse(message)
                if(last_message.msg=="ping"){
                    secureWebSocket.sendTextMessage("{ \"msg\": \"pong\"}")
                }

            }
            onStatusChanged: if (secureWebSocket.status == WebSocket.Error) {
                                 console.log("Error: " + secureWebSocket.errorString)
                             } else if (secureWebSocket.status == WebSocket.Open) {
                                 secureWebSocket.sendTextMessage("Hello Secure World")
                             } else if (secureWebSocket.status == WebSocket.Closed) {
                                 messageBox.text += "\nSecure socket closed"
                             }
            active: true
        }

        TextEdit {
            id: messageBox
            text: secureWebSocket.status == WebSocket.Open ? qsTr("Sending...") : qsTr("Welcome!")
            width: parent.width
            height: parent.height/3
            anchors.bottom: parent.bottom
        }

        Row{
            Button{
                text: "Connect"
                onClicked: {
                    secureWebSocket.sendTextMessage("{ \"msg\": \"connect\", \"version\": \"1\" , \"support\":[\"1\"] }")
                    //Qt.quit();
                }
            }
            Button{
                text: "Connect Methor"
                onClicked: {
                    messageBox.text = messageBox.text + "\n {\"msg\": \"method\", \"method\":\"login\",
                                                       \"params\":[\"user\":{\"email\":\"lorenzo.lucignano@epfl.ch\"},\"password\":\"lorello88\"],\"randomSeed\":\"1\",\"id\":\"blabla\" }"
                    secureWebSocket.sendTextMessage("{ \"msg\": \"method\", \"method\":\"login\",
                                                       \"params\":[{\"user\":{\"email\":\"lorenzo.lucignano@epfl.ch\"},\"password\":\"lorello88\"}],\"randomSeed\":\"ffgvfhev\",\"id\":\"blabla\" }")
                    //Qt.quit();
                }
            }
            Button{
                text: "Metods Methor"
                onClicked: {
                    secureWebSocket.sendTextMessage("{ \"msg\": \"sub\",
                                                      \"id\":\"HYcJFT9uua7EX5Gmi\",\"name\":\"openActivities\" }")
                     //Qt.quit();
                }
            }
        }
}
