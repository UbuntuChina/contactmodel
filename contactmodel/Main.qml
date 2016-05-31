import QtQuick 2.4
import Ubuntu.Components 1.3
import QtContacts 5.0
import Ubuntu.Components.ListItems 1.0 as ListItem

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "contactmodel.liu-xiao-guo"

    width: units.gu(100)
    height: units.gu(75)


    ContactModel {
        id: mymodel
        sortOrders: [
            SortOrder {
                id: sortOrder

                detail: ContactDetail.Name
                field: Name.FirstName
                direction: Qt.DescendingOrder
            }
        ]

        fetchHint: FetchHint {
            detailTypesHint: [ContactDetail.Avatar,
                ContactDetail.Name,
                ContactDetail.PhoneNumber]
        }

//        filter: DetailFilter {
//            id: favouritesFilter

//            detail: ContactDetail.Favorite
//            field: Favorite.Favorite
//            value: "Yang"
//            matchFlags: DetailFilter.MatchExactly
//        }

        filter: DetailFilter {
            id: nameFilter

            detail: ContactDetail.Name
            field: Name.LastName
            value: "Yang"
            matchFlags: DetailFilter.MatchExactly
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: parent.width
            height: manager.delegate.height
            color: "lightsteelblue"; radius: 5
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }


    Page {
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("contactmodel")
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top:pageHeader.bottom
            }

            Column {
                anchors.fill: parent
                spacing: units.gu(0.5)

                Label {
                    text: "The contact managers:"
                    fontSize: "x-large"
                }

                ListView {
                    id: manager
                    clip: true
                    width: parent.width
                    height: units.gu(8)
                    highlight: highlight
                    model: mymodel.availableManagers
                    delegate: Item {
                        id: delegate
                        width: manager.width
                        height: man.height
                        Label {
                            id: man
                            text: modelData
                            fontSize: "large"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                manager.currentIndex = index
                                // set the contact model manager
                                mymodel.manager = modelData
                            }
                        }
                    }
                }

                Rectangle {
                    id: divider
                    width: parent.width
                    height: units.gu(0.1)
                    color: "green"
                }

                CustomListItem {
                    id: storage
                    title.text: {
                        switch (mymodel.storageLocations ) {
                        case ContactModel.UserDataStorage:
                            return "UserDataStorage";
                        case ContactModel.SystemStorage:
                            return "SystemStorage";
                        default:
                            return "Unknown storage"
                        }
                    }
                }

                // Display the contact info here
                ListView {
                    width: parent.width
                    height: parent.height - manager.height - divider.height - storage.height
                    model: mymodel
                    delegate: ListItem.Subtitled {
                        text: contact.name.firstName + " " + contact.name.lastName
                        subText: contact.phoneNumber.number
                    }
                }
            }
        }

        Component.onCompleted: {
            console.log("count of manager: " + mymodel.availableManagers.length)
        }

    }
}

