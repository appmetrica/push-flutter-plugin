package io.appmetrica.analytics.push.flutter.impl

import org.assertj.core.api.Assertions.assertThat
import io.appmetrica.analytics.push.flutter.FakePushProviderFactory
import io.appmetrica.analytics.push.flutter.FakePushServiceControllerProvider
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

@RunWith(RobolectricTestRunner::class)
class PushProvidersConverterTest {

    @Test
    fun `convert skips unknown factory and creates provider for valid factory`() {
        val application = RuntimeEnvironment.getApplication()
        val providers = PushProvidersConverter.convert(
            application,
            listOf(
                "io.appmetrica.analytics.push.flutter.DoesNotExistFactory",
                FakePushProviderFactory::class.java.name,
            )
        )
        assertThat(providers).hasSize(1)
        assertThat(providers[0]).isInstanceOf(FakePushServiceControllerProvider::class.java)
        assertThat((providers[0] as FakePushServiceControllerProvider).application).isSameAs(application)
    }
}
