package io.appmetrica.analytics.push.flutter;

import android.app.Application;
import androidx.annotation.NonNull;
import io.appmetrica.analytics.push.provider.api.PushServiceControllerProvider;
import io.appmetrica.analytics.push.provider.firebase.FirebasePushServiceControllerProvider;

public class FirebasePushProviderFactory implements PushProviderFactory {

    @NonNull
    @Override
    public PushServiceControllerProvider create(Application application) {
        return new FirebasePushServiceControllerProvider(application);
    }
}
