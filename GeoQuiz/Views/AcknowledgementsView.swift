import SwiftUI

/// Third-party attributions, shipped in-app rather than left in the repo's
/// THIRD_PARTY_LICENSES.md alone — the flag-icons MIT license specifically requires the
/// notice to travel with the distributed software, not just live in source control.
struct AcknowledgementsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    section(title: "Flag Images") {
                        Text("Converted from SVGs in [flag-icons](https://github.com/lipis/flag-icons) by Panayiotis Lipiridis, used under the MIT License:")
                        Text(mitLicenseText)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: 10))
                    }

                    section(title: "Country Border Outlines & Land Borders") {
                        Text("Derived from [datasets/geo-countries](https://github.com/datasets/geo-countries) (boundary data sourced from Natural Earth), used under the Open Data Commons Public Domain Dedication and License (PDDL) — public domain, no attribution required.")
                    }

                    section(title: "Satellite Images") {
                        Text("True-color crops generated from Sentinel-2 L2A data via the Copernicus Data Space Ecosystem's Sentinel Hub Process API.")
                        Text("Contains modified Copernicus Sentinel data (2025–2026)")
                            .font(.footnote.italic())
                            .foregroundStyle(.secondary)
                    }

                    section(title: "Population Data") {
                        Text("Figures come from the POP_EST field in Natural Earth's ne_10m_admin_0_countries dataset (public domain), rounded to the nearest million and not live-updated.")
                    }
                }
                .padding()
            }
            .navigationTitle("Acknowledgements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private func section(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content()
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .tint(Theme.accent)
        }
    }

    private let mitLicenseText = """
    The MIT License (MIT)

    Copyright (c) 2013 Panayiotis Lipiridis

    Permission is hereby granted, free of charge, to any person obtaining a copy of \
    this software and associated documentation files (the "Software"), to deal in \
    the Software without restriction, including without limitation the rights to \
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies \
    of the Software, and to permit persons to whom the Software is furnished to do \
    so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all \
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE \
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE \
    SOFTWARE.
    """
}

#Preview {
    AcknowledgementsView()
}
