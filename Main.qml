import QtQuick 2.2
import QtQuick.Window 2.1
import Ubuntu.Web 0.2
import Ubuntu.Components 1.1
import com.canonical.Oxide 1.0 as Oxide
import "UCSComponents"
import Ubuntu.Content 1.1
import "."
import "config.js" as Conf

Window {
    id: window
    visibility: "AutomaticVisibility"
    property string myUrl: Conf.webappUrl


    property string myUA: "Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36"
    width: units.gu(150)
    height: units.gu(100)

    MainView {
        objectName: "mainView"

        applicationName: "pythondocs.maur"

        useDeprecatedToolbar: false
        anchorToKeyboard: true
        automaticOrientation: true

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Page {
            id: page
            anchors {
                fill: parent
                bottom: parent.bottom
            }
            width: parent.width
            height: parent.height

            WebContext {
                id: webcontext
                userAgent: myUA
                userScripts: [
                    Oxide.UserScript {
                        context: "oxide://"
                        url: Qt.resolvedUrl("../userscripts/ubuntutheme.js")
                        matchAllFrames: true
                    }
                ]
            }
            WebView {
                id: webview
                anchors {
                    fill: parent
                    bottom: parent.bottom
                }
                width: parent.width
                height: parent.height

                context: webcontext
                url: myUrl

                //preferences.appCacheEnabled: true
                preferences.javascriptCanAccessClipboard: true



                Component.onCompleted: {
                    preferences.localStorageEnabled = true
                    if (Qt.application.arguments[1].toString().indexOf("https://docs.python.org/3/") > -1) {
                        console.warn("got argument: " + Qt.application.arguments[1])
                        url = Qt.application.arguments[1]
                    }
                    console.warn("url is: " + url)
                }

            }
            ThinProgressBar {
                webview: webview
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
            }
            RadialBottomEdge {
                id: nav
                visible: true
                actions: [
                 /*   RadialAction {
                        //id: reload
                        iconName: "home"
                        onTriggered: {
                            //webview.reload()
                            webview.location.href="https://docs.python.org/3/"
                        }
                        text: qsTr("Reload")
                    },*/
                    RadialAction {
                        id: reload
                        iconName: "reload"
                        onTriggered: {
                            webview.reload()
                        }
                        text: qsTr("Reload")
                    },

                    RadialAction {
                        id: forward
                        enabled: webview.canGoForward
                        iconName: "go-next"
                        onTriggered: {
                            webview.goForward()

                        }
                       text: qsTr("Forward")
                     },


                    RadialAction {
                        id: back
                        enabled: webview.canGoBack
                        iconName: "go-previous"
                        onTriggered: {
                            webview.goBack()
                        }
                        text: qsTr("Back")
                    }

                ]
            }
        }
    }
}
