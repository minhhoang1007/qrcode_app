package com.example.qrcode_app;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.example.qrcode_app.utils.SharedPrefsUtils;
import com.example.ratedialog.RatingDialog;

import io.flutter.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity  implements RatingDialog.RatingDialogInterFace {
  private static final String CHANNEL = "my_module";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                switch (call.method) {
                  case "change":
                    break;
                  case "openAnotherApp":
                    open(call.argument("data"),result);
                    break;
                  case "rateAuto":
                    rateAuto();
                    break;
                  case "rateManual":
                    rateManual();
                    break;
                  case "goToMarket":
                    goToMarket();
                    break;
                  case "getAppId":
                    result.success(getPackageName());
                    break;
                  case "moveToNewApp":
                    moveToNewApp(call.argument("newAppId"));
                    break;
                }
              }
            });
  }
  void moveToNewApp(String appId){
    Intent intent = new Intent(new Intent(Intent.ACTION_VIEW,
            Uri.parse("http://play.google.com/store/apps/details?id=" + appId)));
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    startActivity(intent);
  }
  void open(String magnet, MethodChannel.Result result) {
    Intent browserIntent = new Intent(Intent.ACTION_VIEW);
    browserIntent.setData(Uri.parse(magnet));
    try {
      startActivity(browserIntent);result.success(true);
    } catch (ActivityNotFoundException ex) {
      Log.d("dddddd", "abcd");
      result.success(false);
    }
  }
  void goToMarket(){
    Intent goToMarket = new Intent(Intent.ACTION_VIEW).setData(Uri.parse("market://search?q=torrent clients"));
    startActivity(goToMarket);
  }
  public static void rateApp(Context context) {
    Intent intent = new Intent(new Intent(Intent.ACTION_VIEW,
            Uri.parse("http://play.google.com/store/apps/details?id=" + context.getPackageName())));
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    context.startActivity(intent);
  }
  public void rateAuto() {
    int rate = SharedPrefsUtils.getInstance(this).getInt("rate");
    if (rate < 2) {
      RatingDialog ratingDialog = new RatingDialog(this);
      ratingDialog.setRatingDialogListener(this);
      ratingDialog.showDialog();
      int r = rate ++;
      SharedPrefsUtils.getInstance(this).putInt("rate", r);
    }
  }
  void rateManual() {
    RatingDialog ratingDialog = new RatingDialog(this);
    ratingDialog.setRatingDialogListener(this);
    ratingDialog.showDialog();
  }
  @Override
  public void onDismiss() {
  }
  @Override
  public void onSubmit(float rating) {
    if (rating > 3) {
      rateApp(this);
      SharedPrefsUtils.getInstance(this).putInt("rate", 5);
    }
  }
  @Override
  public void onRatingChanged(float rating) {
  }

}
