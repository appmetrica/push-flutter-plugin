package io.appmetrica.analytics.push.flutter.impl;

import android.app.Application;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.push.AppMetricaPush;
import io.appmetrica.analytics.push.flutter.pigeon.Pigeon;
import io.appmetrica.analytics.push.provider.api.PushServiceControllerProvider;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppMetricaPushImpl implements Pigeon.AppMetricaPushPigeon {

    private final static String TAG = "[AppMetricaPushImpl]";

    @NonNull
    private final Context context;
    @NonNull
    private final LaunchIntentHolder launchIntentHolder;
    @NonNull
    private final Pigeon.TokenUpdateApi tokenUpdateApi;

    @Nullable
    private Application application;

    @NonNull
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    public AppMetricaPushImpl(
        @NonNull final Context context,
        @NonNull final LaunchIntentHolder launchIntentHolder,
        @NonNull final Pigeon.TokenUpdateApi tokenUpdateApi
    ) {
        this.context = context;
        this.launchIntentHolder = launchIntentHolder;
        this.tokenUpdateApi = tokenUpdateApi;
    }

    @Override
    public void activate() {
        AppMetricaPush.activate(context);
        AppMetricaPush.setTokenUpdateListener(newTokens ->
            mainHandler.post(() ->
                tokenUpdateApi.onTokenUpdated(newTokens, reply -> {})
            )
        );
    }

    @Override
    public void activateWithProviders(@NonNull List<String> providers) {
        if (application == null) {
            Log.w(TAG, "AppMetrica Push SDK is not activated since application is null");
            return;
        }

        AppMetricaPush.activate(
            context,
            PushProvidersConverter.convert(application, providers).toArray(new PushServiceControllerProvider[0])
        );
        AppMetricaPush.setTokenUpdateListener(newTokens ->
            mainHandler.post(() ->
                tokenUpdateApi.onTokenUpdated(newTokens, reply -> {})
            )
        );
    }

    @Override
    public void requestPermission(@NonNull Pigeon.PermissionOptions options) {
        // do nothing
    }

    @Override
    public void enableLogger() {
        AppMetricaPush.enableLogger();
    }

    @Override
    public void getTokens(@NonNull Pigeon.Result<Map<String, String>> result) {
        final Map<String, String> tokens = AppMetricaPush.getTokens();
        result.success(tokens != null ? tokens : new HashMap<>());
    }

    @Override
    public void getLaunchPushInfo(@NonNull Pigeon.Result<Pigeon.AppMetricaPushInfoPigeon> result) {
        result.success(IntentToPushInfoConverter.convert(launchIntentHolder.initialIntent));
    }

    public void setApplication(@NonNull Application application) {
        this.application = application;
    }
}
