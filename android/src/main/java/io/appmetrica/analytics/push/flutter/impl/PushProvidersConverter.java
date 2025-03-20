package io.appmetrica.analytics.push.flutter.impl;

import android.app.Application;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.push.flutter.PushProviderFactory;
import io.appmetrica.analytics.push.provider.api.PushServiceControllerProvider;
import java.util.ArrayList;
import java.util.List;

public class PushProvidersConverter {

    private static final String TAG = "[PushProvidersConverter]";

    @NonNull
    public static List<PushServiceControllerProvider> convert(
        @NonNull Application application,
        @NonNull List<String> factoryClasses
    ) {
        final List<PushServiceControllerProvider> providers = new ArrayList<>();
        for (String factoryClass : factoryClasses) {
            PushProviderFactory pushProviderFactory = createFactory(factoryClass);
            if (pushProviderFactory != null) {
                providers.add(pushProviderFactory.create(application));
            }
        }
        return providers;
    }

    @Nullable
    private static PushProviderFactory createFactory(@NonNull String factoryClass) {
        try {
            return (PushProviderFactory) Class.forName(factoryClass).newInstance();
        } catch (Throwable e) {
            return null;
        }
    }
}
