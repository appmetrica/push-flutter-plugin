package io.appmetrica.analytics.push.flutter.impl;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import io.appmetrica.analytics.push.AppMetricaPush;
import io.appmetrica.analytics.push.flutter.pigeon.Pigeon;
import io.appmetrica.analytics.push.plugin.adapter.internal.AppMetricaConfigStorage;
import java.util.HashMap;
import java.util.Map;

public class AppMetricaPushImpl implements Pigeon.AppMetricaPushPigeon {

    @NonNull
    private final Context context;
    @NonNull
    private final Pigeon.TokenUpdateApi tokenUpdateApi;

    @NonNull
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    public AppMetricaPushImpl(
        @NonNull final Context context,
        @NonNull final Pigeon.TokenUpdateApi tokenUpdateApi
    ) {
        this.context = context;
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
    public void requestPermission(@NonNull Pigeon.PermissionOptions options) {
        // do nothing
    }

    @Override
    public void saveAppMetricaConfig(@NonNull String config) {
        AppMetricaConfigStorage.saveConfig(context, config);
    }

    @Override
    public void getTokens(@NonNull Pigeon.Result<Map<String, String>> result) {
        final Map<String, String> tokens = AppMetricaPush.getTokens();
        result.success(tokens != null ? tokens : new HashMap<>());
    }
}
