//package com.site.tech.messager;
//
//import android.annotation.SuppressLint;
//import android.app.ActivityManager;
//import android.app.KeyguardManager;
//import android.app.Notification;
//import android.app.NotificationManager;
//import android.app.PendingIntent;
//import android.content.Context;
//import android.content.Intent;
//import android.content.pm.PackageManager;
//import android.media.MediaPlayer;
//import android.os.Build;
//import android.os.PowerManager;
//
//import android.text.TextUtils;
//import android.util.Log;
//import android.widget.RemoteViews;
//
//import androidx.annotation.NonNull;
//import androidx.core.app.ActivityCompat;
//import androidx.core.app.NotificationCompat;
//import androidx.core.app.NotificationManagerCompat;
//
//import com.google.android.gms.tasks.OnCompleteListener;
//import com.google.android.gms.tasks.Task;
//import com.google.firebase.messaging.FirebaseMessaging;
//import com.google.firebase.messaging.FirebaseMessagingService;
//import com.google.firebase.messaging.RemoteMessage;
//
//import java.text.DateFormat;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//import java.util.Map;
//
//
//public class FirebaseService extends FirebaseMessagingService {
//
//    private final static String TAG = FirebaseService.class.getSimpleName();
//
//    private KeyguardManager keyguard;
//    private KeyguardManager.KeyguardLock keylock;
//    private PowerManager.WakeLock wakelock;
//    private String mTitle = "";
//    private String mBody = "";
//    MediaPlayer mediaPlayer = null;
//
//    @Override
//    public void onMessageReceived(RemoteMessage message) {
//
//        mediaPlayer = MediaPlayer.create(this, R.raw.phone);
//        mediaPlayer.setLooping(true);
//        mediaPlayer.start();
//
//        String from = message.getFrom();
//        Map<String, String> data = message.getData();
//        RemoteMessage.Notification notification = message.getNotification();
//        if (notification != null) {
//            mTitle = notification.getTitle();
//            mBody = notification.getBody();
//        }
//        Log.d(TAG, "from:" + from);
//        Log.d(TAG, "data:" + data.toString());
//
//        FirebaseMessaging.getInstance().getToken()
//                .addOnCompleteListener(new OnCompleteListener<String>() {
//                    @Override
//                    public void onComplete(@NonNull Task<String> task) {
//                        if (!task.isSuccessful()) {
//                            Log.w(TAG, "Fetching FCM registration token failed", task.getException());
//                            return;
//                        }
//
//                        // Get new FCM registration token
//                        String token = task.getResult();
//
//
//
//                    }
//                });
//
//        try {
//
//            int uniqueID = (int) System.currentTimeMillis();
//            if (message.getData().size() > 0) {
//                String title = data.get("title");
//                if (title == null) {
//                    title = "";
//                }
//                NotificationCompat.Builder builder = null;
//                String text = "";
//                text = mBody;
//
//                builder = new NotificationCompat.Builder(getApplicationContext(), "messageNotificationChannelId");
//                builder.setSmallIcon(R.mipmap.ic_launcher);
//                builder.setContentTitle(title);
//                builder.setContentText(text);
//                builder.setDefaults(Notification.DEFAULT_SOUND
//                        | Notification.DEFAULT_VIBRATE
//                        | Notification.DEFAULT_LIGHTS);
//                builder.setAutoCancel(true);
//                Intent intent1;
//
//                intent1 = new Intent(this, MainActivity.class);
//
//                PendingIntent contentIntent;
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//                    contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent1, PendingIntent.FLAG_MUTABLE);
//                } else {
//                    try {
//                        contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent1, PendingIntent.FLAG_UPDATE_CURRENT);
//                    } catch (Exception e) {
//                        contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent1, PendingIntent.FLAG_MUTABLE);
//                    }
//                }
//                builder.setContentIntent(contentIntent);
//
//                builder.setAutoCancel(true);
//
//                // Notification表示
//                NotificationManagerCompat manager = NotificationManagerCompat.from(getApplicationContext());
//                if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) {
//                    manager.notify(uniqueID, builder.build());
//                }
//            }
//
//
//
//
//
//        } catch (Exception e) {
//            e.getStackTrace();
//        }
//    }
//
////    @SuppressLint("NotificationTrampoline")
////    public void notification(RemoteMessage remoteMessage, String call_status, String user_name,
////                             String user_id, String group_id, String group_name, String kind,
////                             String file, String task_id, String to_user_id , String notifybody , String message_id) {
////        ChatLifecycleListener lifecycleListener = new ChatLifecycleListener();
////        String currentActivityName = lifecycleListener.getCurrentActivityName();
////        int uniqueID = (int) System.currentTimeMillis();
////
////        // Check if message contains a data payload.
////        if (remoteMessage.getData().size() > 0) {
////            Log.d(TAG, "Message data payload: " + remoteMessage.getData());
////
////            NotificationCompat.Builder builder = null;
////            String title = "";
////            String text = "";
////            if (call_status.equals("contact")) {
////                title = "仲間追加";
////                text = user_name + "さんから仲間追加申請が届きました。";
////                // Notificationを生成
////                builder = new NotificationCompat.Builder(getApplicationContext(), Constants.MESSAGE_CHANNEL_ID);
////
////            } else if (call_status.equals("task_limit")) {
////                title = "タスク";
////                text = "タスクの期限が近づいています。";
////                // Notificationを生成
////                builder = new NotificationCompat.Builder(getApplicationContext(), Constants.TASK_CHANNEL_ID);
////
////            } else if (call_status.equals("project_contact")){
////
////                title = mTitle;
////                text = mBody;
////                builder = new NotificationCompat.Builder(getApplicationContext(), Constants.TASK_CHANNEL_ID);
////            } else if (call_status.equals("project_qr")){
////
////                title = mTitle;
////                text = mBody;
////                builder = new NotificationCompat.Builder(getApplicationContext(), Constants.MESSAGE_CHANNEL_ID);
////            } else {
////                title = "メッセージ受信";
//////                text = user_name + "さんからメッセージが届きました。";
////                text = notifybody;
////                // Notificationを生成
////                builder = new NotificationCompat.Builder(getApplicationContext(), Constants.MESSAGE_CHANNEL_ID);
////            }
////
////            // Notificationを生成
////            //NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), Constants.MESSAGE_CHANNEL_ID);
////            builder.setSmallIcon(R.drawable.chat_notify);
////            //builder.setContentTitle(getString(R.string.app_name));
////            builder.setContentTitle(title);
////            builder.setContentText(text);
////            builder.setDefaults(Notification.DEFAULT_SOUND
////                    | Notification.DEFAULT_VIBRATE
////                    | Notification.DEFAULT_LIGHTS);
////            builder.setAutoCancel(true);
////
////            if (call_status.equals("message_like")){
////                builder.setStyle(new NotificationCompat.BigTextStyle().bigText(text));
////            }
////            // タップ時に呼ばれるIntentを生成
////            //if (ChatApplication.getInstance().isExistActivity) {
////
////                if (call_status.equals("contact")) {
////                    Log.d("Service", "open agreement");;
////                    Intent intent = new Intent(this, AgreementActivity.class);
////                    intent.putExtra("user_name", user_name);
////                    intent.putExtra("user_id", Integer.parseInt(group_id));
////                    intent.putExtra("from_user_id", Integer.parseInt(user_id));
////                    intent.putExtra("type", "1");
////                    if (TextUtils.isEmpty(currentActivityName)){
////                        intent.putExtra("isHasCurrentActivity", true);
////                    }
////                    if (to_user_id != null && !to_user_id.isEmpty()) intent.putExtra(Constants.TO_USER_ID, Integer.parseInt(to_user_id));
////                    PendingIntent contentIntent ;
////                    if (Util.isAndroidS()){
////                        contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                    }else {
////                        try {
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////                        } catch (Exception e) {
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                        }
////                    }
////                    builder.setContentIntent(contentIntent);
////
////                } else if (call_status.equals("project_qr")) {
////
////                    Intent intent = new Intent(this, MenuActivity.class);
////                    intent.putExtra("project_show",1);
////                    PendingIntent contentIntent ;
////                    if (Util.isAndroidS()){
////                        contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                    }else {
////                        try {
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////                        } catch (Exception e) {
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                        }
////                    }
////                    builder.setContentIntent(contentIntent);
////                } else if (call_status.equals("task_limit")) {
////                    Intent intent = new Intent(this, TaskDetailActivity.class);
////                    intent.putExtra("group_id", group_id);
////                    intent.putExtra("group_name", group_name);
////                    intent.putExtra("user_id", Integer.parseInt(to_user_id));
////                    intent.putExtra("user_name", user_name);
////                    //intent.putExtra("message", "");
////                    //intent.putExtra("file_name", "");
////                    //intent.putExtra("timestamp", 0);
////                    //intent.putExtra("message_id", 0);
////                    //intent.putExtra("date_time", "");
////                    //intent.putExtra("max_id", 0);
////                    //intent.putExtra("member", "");
////                    intent.putExtra("task_id", Integer.parseInt(task_id));
////                    if (TextUtils.isEmpty(currentActivityName)){
////                        intent.putExtra("isHasCurrentActivity", true);
////                    }
////                    //intent.putExtra("limit_date", "");
////                    PendingIntent contentIntent ;
////                    if (Util.isAndroidS()){
////                        contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                    }else {
////                        try {
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////                        } catch (Exception e) {
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                        }
////                    }
////                    builder.setContentIntent(contentIntent);
////
////                } else if (call_status.equals("project_contact")){
////                    if (Util.isAndroidS()){
////                        Intent intent;
////                        if (isBackground(getApplicationContext())){
////                            intent = new Intent(this, BroadcastActivity.class);
////                        }else {
////                            intent = new Intent(this, ToMainActivityBroadcastReceiver.class);
////                        }
////                        intent.putExtra("canclekind", "-1");
////                        intent.putExtra("cancleid", uniqueID);
////                        if (TextUtils.isEmpty(currentActivityName)){
////                            intent.putExtra("isHasCurrentActivity", true);
////                        }
////                        PendingIntent contentIntent;
////                        if (isBackground(getApplicationContext())){
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                        }else {
////                            contentIntent  = PendingIntent.getBroadcast(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                        }
////                        builder.setContentIntent(contentIntent);
////                    }else {
////                        Intent intent = new Intent(this, ToMainActivityBroadcastReceiver.class);
////                        intent.putExtra("canclekind", "-1");
////                        intent.putExtra("cancleid", uniqueID);
////                        if (TextUtils.isEmpty(currentActivityName)){
////                            intent.putExtra("isHasCurrentActivity", true);
////                        }
////                        PendingIntent contentIntent = PendingIntent.getBroadcast(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////                        builder.setContentIntent(contentIntent);
////                    }
////                } else {
////                    if (Util.isAndroidS()){
////                        Intent intent;
////                        if (isBackground(getApplicationContext())){
////                            intent = new Intent(this, BroadcastActivity.class);
////                        }else {
////                            intent = new Intent(this, ToMainActivityBroadcastReceiver.class);
////                        }
////                        intent.putExtra("user_name", user_name);
////                        intent.putExtra("user_id", to_user_id);
////                        intent.putExtra("group_id", group_id);
////                        intent.putExtra("group_name", group_name);
////                        intent.putExtra("kind", kind);
////                        intent.putExtra("file", file);
////                        intent.putExtra("message_id", message_id);
////                        if (TextUtils.isEmpty(currentActivityName)){
////                            intent.putExtra("isHasCurrentActivity", true);
////                        }
////                        PendingIntent contentIntent;
////                        if (isBackground(getApplicationContext())){
////                            contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                        }else {
////                            contentIntent  = PendingIntent.getBroadcast(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                        }
////                        builder.setContentIntent(contentIntent);
////                    }else {
////                        Intent intent = new Intent(this, ToMainActivityBroadcastReceiver.class);
////                        intent.putExtra("user_name", user_name);
////                        intent.putExtra("user_id", to_user_id);
////                        intent.putExtra("group_id", group_id);
////                        intent.putExtra("group_name", group_name);
////                        intent.putExtra("kind", kind);
////                        intent.putExtra("file", file);
////                        intent.putExtra("message_id", message_id);
////                        if (TextUtils.isEmpty(currentActivityName)){
////                            intent.putExtra("isHasCurrentActivity", true);
////                        }
////                        PendingIntent contentIntent = PendingIntent.getBroadcast(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////                        builder.setContentIntent(contentIntent);
////                    }
////                }
/////*
////            } else {
////                Log.d(TAG, "Open Login!!!");
////                Intent intent = new Intent(this, LoginActivity.class);
////                intent.putExtra("user_name", user_name);
////                intent.putExtra("user_id", user_id);
////                intent.putExtra("group_id", group_id);
////                intent.putExtra("group_name", group_name);
////                intent.putExtra("kind", kind);
////                intent.putExtra("file", file);
////                PendingIntent contentIntent = PendingIntent.getActivity(getApplicationContext(), 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////                builder.setContentIntent(contentIntent);
////            }
////*/
////            // タップで通知領域から削除する
////            builder.setAutoCancel(true);
////
////            // Notification表示
////            NotificationManagerCompat manager = NotificationManagerCompat.from(getApplicationContext());
////            manager.notify(uniqueID, builder.build());
////        } else
////
////        // Check if message contains a notification payload.
////        if (remoteMessage.getNotification() != null) {
////            Log.d(TAG, "Message Notification Body: " + remoteMessage.getNotification().getBody());
////
////            RemoteMessage.Notification notification = remoteMessage.getNotification();
////            String title = notification.getTitle();
////            String body = notification.getBody();
////            NotificationCompat.Builder builder =
////                    new NotificationCompat.Builder(
////                            getApplicationContext(), Constants.MESSAGE_CHANNEL_ID)
////                            .setSmallIcon(R.drawable.chat_notify)
////                            .setContentTitle(title)
////                            .setContentText(body);
////
////            NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
////            manager.notify(uniqueID, builder.build());
////        }
////
////        MyPreferenceManager mPreferenceManager = new MyPreferenceManager(ChatApplication.getContext());
////        String list = mPreferenceManager.getString("notifylist");
////        List<NotifyBean> notifyList = new ArrayList<>();
////        Gson gson = new Gson();
////        if (list.equals(" ")){
////            NotifyBean bean = new NotifyBean(group_id,uniqueID);
////            if (call_status.equals("message_like")){
////                bean.setMessageLike(true);
////            }else {
////                bean.setMessageLike(false);
////            }
////            notifyList.add(bean);
////            String liststring = gson.toJson(notifyList);
////            mPreferenceManager.commitString("notifylist",liststring);
////        }else {
////
////            notifyList = gson.fromJson(list,new TypeToken<List<NotifyBean>>(){}.getType());
////            NotifyBean bean = new NotifyBean(group_id,uniqueID);
////            if (call_status.equals("message_like")){
////                bean.setMessageLike(true);
////            }else {
////                bean.setMessageLike(false);
////            }
////            notifyList.add(bean);
////            String liststring = gson.toJson(notifyList);
////            mPreferenceManager.commitString("notifylist",liststring);
////        }
////        // Also if you intend on generating your own notifications as a result of a received FCM
////        // message, here is where that should be initiated. See sendNotification method below.
////    }
//
//    @SuppressLint("InvalidWakeLockTag")
//    private void wakeFromSleep() {
//        wakelock = ((PowerManager) getSystemService(android.content.Context.POWER_SERVICE))
//                .newWakeLock(PowerManager.FULL_WAKE_LOCK
//                        | PowerManager.ACQUIRE_CAUSES_WAKEUP
//                        | PowerManager.ON_AFTER_RELEASE, "disableLock");
//        wakelock.acquire(20000);
//
//        keyguard = (KeyguardManager) getSystemService(android.content.Context.KEYGUARD_SERVICE);
//        keylock = keyguard.newKeyguardLock("disableLock");
//        keylock.disableKeyguard();
//    }
//
////    private void shownoti(String content,String tit, String call_status, String user_name,
////                          String user_id, String group_id, String group_name, String kind,
////                          String file, String task_id, String to_user_id) {
////        String l = System.currentTimeMillis()+"";
////        int id = Integer.parseInt(l.substring(l.length()-6,l.length()-1));
////        RemoteViews remoteViews = new RemoteViews(getPackageName(), R.layout.layout_notification);
////        String title = tit;
////        String text = content;
////        Intent intent = new Intent(this, JoinBroadcastReceiver.class);
////        intent.putExtra("user_name", user_name);
////        intent.putExtra("user_id", user_id);
////        intent.putExtra("group_id", group_id);
////        intent.putExtra("group_name", group_name);
////        intent.putExtra("kind", kind);
////        intent.putExtra("file", file);
////        intent.putExtra("call_status", call_status);
////        PendingIntent contentIntent2 = PendingIntent.getBroadcast(getApplicationContext(), id, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////        remoteViews.setOnClickPendingIntent(R.id.join, contentIntent2);
////
////        Intent nojionIntent =new Intent(this, NoJoinBroadcastReceiver.class);
////        nojionIntent.putExtra("notification_id", id);
////        nojionIntent.putExtra("user_name", user_name);
////        nojionIntent.putExtra("user_id", user_id);
////        nojionIntent.putExtra("group_id", group_id);
////        nojionIntent.putExtra("group_name", group_name);
////        nojionIntent.putExtra("kind", kind);
////        nojionIntent.putExtra("file", file);
////        nojionIntent.putExtra("call_status", call_status);
////        PendingIntent contentIntent1 = PendingIntent.getBroadcast(getApplicationContext(), id, nojionIntent, PendingIntent.FLAG_UPDATE_CURRENT);
////        remoteViews.setOnClickPendingIntent(R.id.nojoin, contentIntent1);
////        Date date = new Date();
////        DateFormat dateTimeFormat = new SimpleDateFormat("HH:mm");
////        String nowDateTimeTxt = dateTimeFormat.format(date);
////        remoteViews.setTextViewText(R.id.tv_name, getString(R.string.app_name)+ "    "+nowDateTimeTxt );
////        remoteViews.setTextViewText(R.id.tv_titile, title);
////        remoteViews.setTextViewText(R.id.tv_content, text);
////
////        NotificationCompat.Builder builder = null;
////        builder = new NotificationCompat.Builder(getApplicationContext(), Constants.MESSAGE_CHANNEL_ID);
////        builder.setSmallIcon(R.drawable.chat_notify);
////        builder.setContentTitle(title);
////        builder.setContentText(text);
////        builder.setCustomHeadsUpContentView(remoteViews);
////        builder.setDefaults(Notification.DEFAULT_SOUND
////                | Notification.DEFAULT_VIBRATE
////                | Notification.DEFAULT_LIGHTS);
////        builder.setAutoCancel(true);
////        Intent intenta = new Intent(this, CallActivity.class);
////        intenta.putExtra("user_name", user_name);
////        intenta.putExtra("user_id", user_id);
////        intenta.putExtra("group_id", group_id);
////        intenta.putExtra("group_name", group_name);
////        intenta.putExtra("kind", kind);
////        intenta.putExtra("file", file);
////        intenta.putExtra("call_status", call_status);
////        PendingIntent contentIntent = PendingIntent.getActivity(getApplicationContext(), id, intenta, PendingIntent.FLAG_UPDATE_CURRENT);
////        builder.setContentIntent(contentIntent);
////        builder.setAutoCancel(true);
////
////        // Notification表示
////        NotificationManagerCompat manager = NotificationManagerCompat.from(getApplicationContext());
////        manager.notify(id, builder.build());
////    }
////    private void shownotiToCall(String content,String tit, String call_status, String user_name,
////                          String user_id, String group_id, String group_name, String kind,
////                                String file, String task_id, String to_user_id) {
////        String l = System.currentTimeMillis()+"";
////        int id = Integer.parseInt(l.substring(l.length()-6,l.length()-1));
////        String title = tit;
////        String text = content;
////
////        Date date = new Date();
////        DateFormat dateTimeFormat = new SimpleDateFormat("HH:mm");
////        ChatLifecycleListener lifecycleListener = new ChatLifecycleListener();
////        String currentActivityName = lifecycleListener.getCurrentActivityName();
////        NotificationCompat.Builder builder = null;
////        builder = new NotificationCompat.Builder(getApplicationContext(), Constants.MESSAGE_CHANNEL_ID);
////        builder.setSmallIcon(R.drawable.chat_notify);
////        builder.setContentTitle(title);
////        builder.setContentText(text);
////        builder.setDefaults(Notification.DEFAULT_SOUND
////                | Notification.DEFAULT_VIBRATE
////                | Notification.DEFAULT_LIGHTS);
////        builder.setAutoCancel(true);
////        if (ChatApplication.currentGroupId == Integer.parseInt(group_id)&&kind.equals("0")){
////            int uniqueID = (int) System.currentTimeMillis();
////            if (Util.isAndroidS()){
////                Intent intent;
////                if (isBackground(getApplicationContext())){
////                    intent = new Intent(this, BroadcastActivity.class);
////                }else {
////                    intent = new Intent(this, ToMainActivityBroadcastReceiver.class);
////                }
////                intent.putExtra("user_name", user_name);
////                intent.putExtra("user_id", to_user_id);
////                intent.putExtra("group_id", group_id);
////                intent.putExtra("group_name", group_name);
////                intent.putExtra("kind", kind);
////                intent.putExtra("file", file);
////                if (TextUtils.isEmpty(currentActivityName)){
////                    intent.putExtra("isHasCurrentActivity", true);
////                }
////                PendingIntent contentIntent;
////                if (isBackground(getApplicationContext())){
////                    contentIntent = PendingIntent.getActivity(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                }else {
////                    contentIntent  = PendingIntent.getBroadcast(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_MUTABLE);
////                }
////                builder.setContentIntent(contentIntent);
////            }else {
////                Intent intent = new Intent(this, ToMainActivityBroadcastReceiver.class);
////                intent.putExtra("user_name", user_name);
////                intent.putExtra("user_id", to_user_id);
////                intent.putExtra("group_id", group_id);
////                intent.putExtra("group_name", group_name);
////                intent.putExtra("kind", kind);
////                intent.putExtra("file", file);
////                if (TextUtils.isEmpty(currentActivityName)){
////                    intent.putExtra("isHasCurrentActivity", true);
////                }
////                PendingIntent contentIntent = PendingIntent.getBroadcast(getApplicationContext(), uniqueID, intent, PendingIntent.FLAG_UPDATE_CURRENT);
////                builder.setContentIntent(contentIntent);
////            }
////        }else {
////            Intent intenta = new Intent(this, CallActivity.class);
////            intenta.putExtra("user_name", user_name);
////            intenta.putExtra("user_id", user_id);
////            intenta.putExtra("group_id", group_id);
////            intenta.putExtra("group_name", group_name);
////            intenta.putExtra("kind", kind);
////            intenta.putExtra("file", file);
////            intenta.putExtra("call_status", call_status);
////            if (TextUtils.isEmpty(currentActivityName)){
////                intenta.putExtra("isHasCurrentActivity", true);
////            }
////            PendingIntent contentIntent ;
////            if (Util.isAndroidS()){
////                contentIntent = PendingIntent.getActivity(getApplicationContext(), id, intenta, PendingIntent.FLAG_MUTABLE);
////            }else {
////                contentIntent = PendingIntent.getActivity(getApplicationContext(), id, intenta, PendingIntent.FLAG_UPDATE_CURRENT);
////            }
////            builder.setContentIntent(contentIntent);
////            builder.setAutoCancel(true);
////        }
////
////        // Notification表示
////        NotificationManagerCompat manager = NotificationManagerCompat.from(getApplicationContext());
////        manager.notify(id, builder.build());
////
////
////        MyPreferenceManager mPreferenceManager = new MyPreferenceManager(ChatApplication.getContext());
////        String list = mPreferenceManager.getString("notifylist");
////        List<NotifyBean> notifyList = new ArrayList<>();
////        Gson gson = new Gson();
////        if (list.equals(" ")){
////            NotifyBean bean = new NotifyBean(group_id,id);
////            notifyList.add(bean);
////            String liststring = gson.toJson(notifyList);
////            mPreferenceManager.commitString("notifylist",liststring);
////        }else {
////
////            notifyList = gson.fromJson(list,new TypeToken<List<NotifyBean>>(){}.getType());
////            NotifyBean bean = new NotifyBean(group_id,id);
////            notifyList.add(bean);
////            String liststring = gson.toJson(notifyList);
////            mPreferenceManager.commitString("notifylist",liststring);
////        }
////    }
//    public static boolean isBackground(Context context) {
//
//
//        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
//        List<ActivityManager.RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
//        for (ActivityManager.RunningAppProcessInfo appProcess : appProcesses) {
//            if (appProcess.processName.equals(context.getPackageName())) {
//                if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
//                    System.out.print(String.format("Foreground App:", appProcess.processName));
//                    return false;
//                }else{
//                    System.out.print("Background App:"+appProcess.processName);
//                    return true;
//                }
//            }
//        }
//        return false;
//    }
//
//    @SuppressLint("WrongThread")
//    @Override
//    public void onNewToken(@NonNull String token) {
//
//
//        String refreshedToken = token;
//
//        if (refreshedToken != null) {
//
//            Log.d(TAG, "Refreshed token: " + refreshedToken);
//        }
//        super.onNewToken(token);
//    }
//
//}
//
