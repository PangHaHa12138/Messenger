package com.site.tech.messager;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import com.site.tech.messager.R;

import androidx.annotation.Nullable;

public class ForegroundService extends Service {
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        if (intent == null) {
            stopSelf();
            return super.onStartCommand(intent, flags, startId);
        }

        String title = intent.getStringExtra("title");
        String description = intent.getStringExtra("description");

        Intent nfIntent = new Intent(this, MainActivity.class);
        Notification.Builder builder = new Notification.Builder(this.getApplicationContext())
//                    .setContentIntent(PendingIntent.getActivity(this, 0, nfIntent, 0)) // set PendingIntent
                .setContentIntent(PendingIntent.getActivity(this, 1, nfIntent,  PendingIntent.FLAG_IMMUTABLE)) // set PendingIntent

                .setSmallIcon(R.mipmap.ic_launcher) // Set the small icon in the status bar
                .setPriority(Notification.PRIORITY_MIN)
                //.setContentTitle(getResources().getString(R.string.app_name))
                .setContentTitle(title)
                .setContentText(description) // set context content
                .setWhen(System.currentTimeMillis()); // Set the time when this notification will occur

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //Modify Android 8.1 above system error
            NotificationChannel notificationChannel = new NotificationChannel("1", "message",  NotificationManager.IMPORTANCE_MIN);
            notificationChannel.enableLights(true);//Indicates whether this notification channel should display a light if the device in use supports it
            notificationChannel.setShowBadge(true);//Whether to display the corner mark
            notificationChannel.enableVibration(true);
            notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);

            NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            manager.createNotificationChannel(notificationChannel);
            builder.setChannelId("1");
        }
        // Get the built Notification
        Notification notification = builder.build();
        notification.defaults = Notification.DEFAULT_SOUND; //set as default sound
        startForeground(1, notification);
        return super.onStartCommand(intent, flags, startId);
    }
}
