package io.appmetrica.analytics.push.flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.appmetrica.analytics.push.flutter.impl.AppMetricaPushImpl;
import io.appmetrica.analytics.push.flutter.impl.LaunchIntentHolder;
import io.appmetrica.analytics.push.flutter.impl.IntentToPushInfoConverter;
import io.appmetrica.analytics.push.flutter.pigeon.Pigeon;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** AppMetricaPushPlugin */
public class AppMetricaPushPlugin implements FlutterPlugin, ActivityAware {

    @Nullable
    private Pigeon.PushReceiverApi pushReceiverApi = null;
    @NonNull
    private final LaunchIntentHolder launchIntentHolder = new LaunchIntentHolder();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        pushReceiverApi = new Pigeon.PushReceiverApi(binding.getBinaryMessenger());

        Pigeon.AppMetricaPushPigeon.setup(
            binding.getBinaryMessenger(),
            new AppMetricaPushImpl(
                binding.getApplicationContext(),
                launchIntentHolder,
                new Pigeon.TokenUpdateApi(binding.getBinaryMessenger())
            ));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        launchIntentHolder.initialIntent = binding.getActivity().getIntent();
        if (pushReceiverApi != null) {
            pushReceiverApi.onPushReceived(IntentToPushInfoConverter.convert(binding.getActivity().getIntent()), reply -> {});
        }
        binding.addOnNewIntentListener(intent -> {
            if (pushReceiverApi != null) {
                pushReceiverApi.onPushReceived(IntentToPushInfoConverter.convert(intent), reply -> {});
            }
            return false;
        });
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        launchIntentHolder.initialIntent = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        launchIntentHolder.initialIntent = binding.getActivity().getIntent();
        if (pushReceiverApi != null) {
            pushReceiverApi.onPushReceived(IntentToPushInfoConverter.convert(binding.getActivity().getIntent()), reply -> {});
        }
        binding.addOnNewIntentListener(intent -> {
            if (pushReceiverApi != null) {
                pushReceiverApi.onPushReceived(IntentToPushInfoConverter.convert(intent), reply -> {});
            }
            return false;
        });
    }

    @Override
    public void onDetachedFromActivity() {
        launchIntentHolder.initialIntent = null;
    }
}
