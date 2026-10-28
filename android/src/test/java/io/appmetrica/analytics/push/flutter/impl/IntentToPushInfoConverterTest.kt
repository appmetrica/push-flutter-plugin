package io.appmetrica.analytics.push.flutter.impl

import android.content.Intent
import io.appmetrica.analytics.push.AppMetricaPush
import io.appmetrica.gradle.testutils.assertions.Assertions.ObjectPropertyAssertions
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

@RunWith(RobolectricTestRunner::class)
class IntentToPushInfoConverterTest {

    @Test
    fun `convert handles null intent and payload extra`() {
        ObjectPropertyAssertions(IntentToPushInfoConverter.convert(null))
            .withPrivateFields(true)
            .withFinalFieldOnly(false)
            .checkFieldIsNull("payload", "getPayload")
            .checkAll()

        val intent = Intent().putExtra(AppMetricaPush.EXTRA_PAYLOAD, "payload-value")
        ObjectPropertyAssertions(IntentToPushInfoConverter.convert(intent))
            .withPrivateFields(true)
            .withFinalFieldOnly(false)
            .checkField("payload", "getPayload", "payload-value")
            .checkAll()
    }
}
