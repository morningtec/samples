package com.yourcompany.features;


import org.stella.lib.StellaActivity;
import android.os.Bundle;
import android.widget.Toast;
import cn.morningtec.BillingSDK.BillingCallback;
import cn.morningtec.BillingSDK.BillingManager;

import android.content.DialogInterface;

import android.app.Dialog;
import android.content.Context;
import android.app.AlertDialog;

import android.widget.TextView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import android.graphics.Color;
import android.util.DisplayMetrics;
import android.util.TypedValue;


public class MainHActivity extends StellaActivity
{
        static
        {

                System.loadLibrary ("stella-rt");
                System.loadLibrary ("stella-base");
                System.loadLibrary ("Foundation");
                System.loadLibrary ("StellaGraphics");
                System.loadLibrary ("StellaKit");
                System.loadLibrary ("Features");


        }

        static MainHActivity      _sharedMainHActivity;



        @Override
        public void onCreate (Bundle savedInstanceState)
        {
                super.onCreate (savedInstanceState);

                /* If you want get the MainView */
                /* RelativeLayout        _mainView  = mainView; */

                RelativeLayout  _mainView       = mainView;

                TextView        _bannerView;
                _bannerView                     = new TextView (this);

                DisplayMetrics metrics          = new DisplayMetrics();
                getWindowManager().getDefaultDisplay().getMetrics(metrics);

                _mainView.addView (_bannerView, new LayoutParams (metrics.widthPixels, metrics.heightPixels/12));
                _bannerView.setBackgroundColor (Color.parseColor("#33B5E5"));
                _bannerView.setText("Hello StellaSDK2");
                _bannerView.setTextSize (TypedValue.COMPLEX_UNIT_PX, 64);

                _sharedMainHActivity     = this;
        }


        /* JNI interface */
        private static native void nativeCallbackMessage (String message);

        public static void sendMessage (String message)
        {
                final String    message_f   = message;

                _sharedMainHActivity.runOnUiThread (new Runnable () {
                        @Override
                        public void run () {
                                /* perform Android UI actions (e.g. alert dialogs) */
                                nativeCallbackMessage (message_f);
                        }
                });
        }

        public static void doBilling ()
        {
                BillingManager.setBillingInfo (_sharedMainHActivity, "pay_point_1_NAME", "item1");
                BillingManager.setBillingInfo (_sharedMainHActivity, "pay_point_1_PRICE", "10");

                BillingManager.doBilling (_sharedMainHActivity, "pay_point_1", new BillingCallback () {
                        @Override
                        public void onBillingSuccess () {
                                Toast.makeText (_sharedMainHActivity, "billing successful", Toast.LENGTH_SHORT).show ();
                        }

                        @Override
                        public void onBillingFail () {
                                Toast.makeText (_sharedMainHActivity, "billing failed", Toast.LENGTH_SHORT).show ();
                        }

                        @Override
                        public void onBillingCancel () {
                                Toast.makeText (_sharedMainHActivity, "billing cancelled", Toast.LENGTH_SHORT).show ();
                        }
                }); 
        }


        public void backButtonPressed ()
        {
                new AlertDialog.Builder (MainHActivity.this)
                        .setTitle ("StellaSDK Features Demo")
                        .setMessage ("Exit the Demo?")
                        .setCancelable (false)
                        .setPositiveButton ("YES", new DialogInterface.OnClickListener () {
                                public void onClick (DialogInterface dialog, int id) {
                                        MainHActivity.this.finish ();
                                }
                        })
                        .setNegativeButton ("NO", new DialogInterface.OnClickListener () {
                                public void onClick (DialogInterface dialog, int id) {
                                        dialog.cancel ();
                                }
                        }).show ();
        }


}


