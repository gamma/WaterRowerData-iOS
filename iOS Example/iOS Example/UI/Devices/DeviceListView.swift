import SwiftUI

struct DeviceListView: View {

    @Binding var devices: [Device]

    var body: some View {
        List(devices) { device in
            NavigationLink(
                destination: DeviceDetailsView(viewModel: DeviceDetailsViewModel(device))
            ) {
                Text(device.name)
            }
        }
    }
}
