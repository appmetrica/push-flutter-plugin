package io.appmetrica.analytics.push.flutter;

import androidx.annotation.NonNull;
import io.appmetrica.analytics.push.flutter.impl.AppMetricaPushImpl;
import io.appmetrica.analytics.push.flutter.pigeon.Pigeon;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/** AppMetricaPushPlugin */
public class AppMetricaPushPlugin implements FlutterPlugin {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Pigeon.AppMetricaPushPigeon.setup(
            binding.getBinaryMessenger(),
            new AppMetricaPushImpl(
                binding.getApplicationContext(),
                new Pigeon.TokenUpdateApi(binding.getBinaryMessenger())
            )
        );
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
