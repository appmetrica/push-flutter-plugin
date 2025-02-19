package io.appmetrica.analytics.push.flutter.impl;

import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.push.AppMetricaPush;
import io.appmetrica.analytics.push.flutter.pigeon.Pigeon;

public class IntentToPushInfoConverter {

    @NonNull
    public static Pigeon.AppMetricaPushInfoPigeon convert(@Nullable Intent intent) {
        Pigeon.AppMetricaPushInfoPigeon pushInfoPigeon = new Pigeon.AppMetricaPushInfoPigeon();
        if (intent != null) {
            pushInfoPigeon.setPayload(intent.getStringExtra(AppMetricaPush.EXTRA_PAYLOAD));
        }
        return pushInfoPigeon;
    }
}
