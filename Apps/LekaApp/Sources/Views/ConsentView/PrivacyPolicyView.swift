// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import MarkdownUI
import SwiftUI

struct PrivacyPolicyView: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Markdown(self.markdownText)
                .markdownTheme(.gitHub)
                .padding()
                .multilineTextAlignment(.leading)
        }
    }

    // MARK: Private

    // swiftlint:disable line_length
    private let markdownText = """
        # Who we are
        The address of our site: [https://leka.io](https://leka.io)

        ## Comments
        When you leave a comment on our site, the data entered in the comment form as well as your IP address and your browser's user-agent are collected to help us detect undesirable comments.

        An anonymized string created from your email address (also called a hash) may be sent to the Gravatar service to verify your use of the service. The Gravatar service privacy policy is available [here](https://automattic.com/privacy/). After validation of your comment, your profile picture will be publicly visible beside your comment.

        ## Media
        If you upload images to the site, we advise you to avoid uploading images that contain EXIF data of GPS coordinates. People visiting your site may download and extract location data from these images.

        ## Cookies
        If you leave a comment on our site, you will be asked to save your name, email address, and site in cookies. This is only for your convenience so that you do not have to enter this information if you leave another comment later. These cookies expire after one year.

        If you go to the login page, a temporary cookie will be created to determine if your browser accepts cookies. It does not contain any personal information and will be deleted automatically when you close your browser.

        When you log in, we will set a number of cookies to store your login information and screen preferences. The lifetime of a login cookie is two days, and the lifetime of a screen option cookie is one year. If you tick “Remember me”, your login cookie will be kept for two weeks. If you log out of your account, the login cookie will be deleted.

        By editing or publishing a post, an additional cookie will be stored in your browser. This cookie does not include any personal information. It simply indicates the ID of the publication you have just modified. It expires after one day.

        ## Embedded content from other sites
        Articles on this site may include embedded content (e.g. videos, images, articles, etc.). Embedded content from other sites behaves in the same way as if the visitor were on that other site.

        These websites may collect data about you, use cookies, embed third-party tracking tools, and track your interactions with such embedded content if you have an account with their website.

        ## Use and disclosure of your personal data
        If you request a password reset, your IP address will be included in the reset email.

        ## How long we store your data
        If you leave a comment, the comment and its metadata are kept indefinitely. This allows us to automatically recognize and approve subsequent comments instead of leaving them in the moderation queue.

        For accounts that register with our site (if any), we also store the personal data listed in their profile. All accounts can view, edit, or delete their personal information at any time (except for their user ID). Site managers can also view and edit this information.

        ## The rights you have over your data
        If you have an account or if you have left comments on the site, you can request to receive a file containing all the personal data that we have about you, including those that you have provided to us. You may also request the deletion of your personal data. This does not include data stored for administrative, legal, or security purposes.

        ## Disclosure of your personal data
        Visitors' comments can be checked using an automated service to detect undesirable comments.
        """
    // swiftlint:enable line_length
}

// MARK: - PrivacyPolicyView_Previews

#Preview {
    PrivacyPolicyView()
}
