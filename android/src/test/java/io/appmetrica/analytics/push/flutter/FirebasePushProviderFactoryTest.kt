package io.appmetrica.analytics.push.flutter

import org.assertj.core.api.Assertions.assertThat
import io.appmetrica.analytics.push.provider.firebase.FirebasePushServiceControllerProvider
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

@RunWith(RobolectricTestRunner::class)
class FirebasePushProviderFactoryTest {

    @Test
    fun `create returns non-null firebase provider`() {
        val provider = FirebasePushProviderFactory().create(RuntimeEnvironment.getApplication())
        assertThat(provider).isNotNull()
        assertThat(provider).isInstanceOf(FirebasePushServiceControllerProvider::class.java)
    }
}
