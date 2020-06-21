import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

QtObject {
    //Выбираем цвет в зависимости от того какая сейчас тема
    property bool isDarkTheme: false
    readonly property color secondaryColor: "#03DAC6"
    readonly property color secondaryVariant: isDarkTheme ? "#018786" : secondaryColor
    readonly property color backgroundColor: isDarkTheme ? "#222222" : "#F2F2F2"
    readonly property color errorColor: isDarkTheme ? "#CF6679" : "#B00020"
    readonly property color textColor: isDarkTheme ? "#FFFFFF" : "#000000"
    readonly property color themeDefaultColor: isDarkTheme ? "#000000" : "#FFFFFF"
    readonly property color themeInvertedColor: isDarkTheme ? "#FFFFFF" : "#000000"
    readonly property color themeOpacityColor: isDarkTheme ? "#60000000" : "#60FFFFFF"

    readonly property real defaultOpacity: 1
    readonly property real emphasisOpacity: 0.87
    readonly property real secondaryOpacity: 0.6
    readonly property real disabledOpacity: 0.38

    readonly property int defaultOffset: 15
    readonly property int mediumOffset: 10
    readonly property int tinyOffset: 5

    readonly property int bigSpacing: 20
    readonly property int mediumSpacing: 10
    readonly property int smallSpacing: 7

}
