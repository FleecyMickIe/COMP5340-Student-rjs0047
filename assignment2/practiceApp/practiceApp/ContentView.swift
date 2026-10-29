import SwiftUI

struct ContentView: View {
    @State private var coffeeQuantity = 0
    @State private var latteQuantity = 0
    @State private var teaQuantity = 0
    @State private var muffinQuantity = 0

    @State private var addTip = false
    @State private var tipPercentage = 10

    var subtotal: Double {
        return Double(
            coffeeQuantity * 3
            + latteQuantity * 5
            + teaQuantity * 3
            + muffinQuantity * 4
        )
    }

    var tipAmount: Double {
        if addTip {
            return subtotal * Double(tipPercentage) / 100
        }

        return 0
    }

    var total: Double {
        return subtotal + tipAmount
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    CoffeeHeader()
                }

                Section("Menu") {
                    ListItem(
                        iconName: "cup.and.saucer.fill",
                        itemName: "Brewed Coffee",
                        price: 3,
                        quantity: $coffeeQuantity
                    )

                    ListItem(
                        iconName: "cup.and.saucer.fill",
                        itemName: "Latte",
                        price: 5,
                        quantity: $latteQuantity
                    )

                    ListItem(
                        iconName: "leaf.fill",
                        itemName: "Tea",
                        price: 3,
                        quantity: $teaQuantity
                    )

                    ListItem(
                        iconName: "birthday.cake.fill",
                        itemName: "Muffin",
                        price: 4,
                        quantity: $muffinQuantity
                    )
                }

                Section("Tip") {
                    PickerItem(
                        addTip: $addTip,
                        tipPercentage: $tipPercentage
                    )
                }

                Section("Order Summary") {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(subtotal, format: .currency(code: "USD"))
                    }

                    if addTip {
                        HStack {
                            Text("Tip (\(tipPercentage)%)")
                            Spacer()
                            Text(tipAmount, format: .currency(code: "USD"))
                        }
                    }

                    HStack {
                        Text("Total")
                        Spacer()
                        Text(total, format: .currency(code: "USD"))
                    }
                    .font(.headline)
                }

                Section {
                    ConfirmItem(total: total)
                        .disabled(subtotal == 0)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("Order")
            .tint(.orange)
        }
    }
}

struct CoffeeHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "cup.and.saucer.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)

            Text("Class Action Coffee")
                .font(.title2)
                .bold()

            Text("Make your case for another cup.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 12)
    }
}

struct ListItem: View {
    var iconName: String
    var itemName: String
    var price: Int

    @Binding var quantity: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .frame(width: 32)

                Text(itemName)
                    .font(.headline)

                Spacer()

                Text(Double(price), format: .currency(code: "USD"))
                    .foregroundStyle(.blue)
                    .fontWeight(.semibold)
            }

            // My new UI element: Stepper adjusts ListItem quantities.
            Stepper(
                "Quantity: \(quantity)",
                value: $quantity,
                in: 0...10
            )
        }
        .padding(.vertical, 8)
    }
}

struct PickerItem: View {
    @Binding var addTip: Bool
    @Binding var tipPercentage: Int

    let tipOptions = [10, 15, 20, 25]

    var body: some View {
        VStack(spacing: 12) {
            Toggle("Add a tip?", isOn: $addTip)

            if addTip {
                Picker("Tip Percentage", selection: $tipPercentage) {
                    ForEach(tipOptions, id: \.self) { option in
                        Text("\(option)%")
                            .tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ConfirmItem: View {
    var total: Double

    @State private var present = false

    var body: some View {
        Button {
            present = true
        } label: {
            Text("Confirm Order")
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .sheet(isPresented: $present) {
            SecondView(present: $present, total: total)
        }
    }
}

struct SecondView: View {
    @Binding var present: Bool

    var total: Double

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("Order Confirmed")
                .font(.title)
                .bold()

            Text("Thank you for choosing Class Action Coffee!")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Text(total, format: .currency(code: "USD"))
                .font(.title2)
                .bold()

            Button("Dismiss") {
                present = false
            }
            .buttonStyle(.bordered)
            .tint(.primary)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
