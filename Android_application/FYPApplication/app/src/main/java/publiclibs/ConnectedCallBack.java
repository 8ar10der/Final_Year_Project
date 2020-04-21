package publiclibs;

import java.io.InputStream;

/**
 * Created by leocai on 16-1-10.
 * 回调函数：连接成功
 */
public interface ConnectedCallBack {
    void onConnected(InputStream out);
}
