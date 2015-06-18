package com.example.mogawa.itunesmusicsearch;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.MediaController;
import android.widget.VideoView;


public class DetailActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        // ActionBarのタイトルを設定する
        String trackName = getIntent().getExtras().getString("track_name");
        getActionBar().setTitle(trackName);

        String previewUrl = getIntent().getExtras().getString("preview_url");
        if (!TextUtils.isEmpty(previewUrl)) {
            VideoView videoView = (VideoView) findViewById(R.id.video_view);
            videoView.setMediaController(new MediaController(this)); // 再生ボタンとかをつける
            videoView.setVideoURI(Uri.parse(previewUrl)); // URLを設定する
            videoView.start(); // 再生する
        }
    }
}
