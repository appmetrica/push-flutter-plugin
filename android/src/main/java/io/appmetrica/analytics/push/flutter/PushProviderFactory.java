package io.appmetrica.analytics.push.flutter;

import android.app.Application;
import androidx.annotation.NonNull;
import io.appmetrica.analytics.push.provider.api.PushServiceControllerProvider;

public interface PushProviderFactory {

    @NonNull
    PushServiceControllerProvider create(Application application);
}
