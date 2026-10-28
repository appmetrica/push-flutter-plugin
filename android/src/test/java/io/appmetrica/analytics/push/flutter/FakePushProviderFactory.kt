package io.appmetrica.analytics.push.flutter

import android.app.Application
import io.appmetrica.analytics.push.provider.api.PushServiceController
import io.appmetrica.analytics.push.provider.api.PushServiceControllerProvider
import org.mockito.Mockito.mock

class FakePushProviderFactory : PushProviderFactory {

    override fun create(application: Application): PushServiceControllerProvider {
        return FakePushServiceControllerProvider(application)
    }
}

class FakePushServiceControllerProvider(
    val application: Application
) : PushServiceControllerProvider {

    override fun getPushServiceController(): PushServiceController = mock(PushServiceController::class.java)
}
