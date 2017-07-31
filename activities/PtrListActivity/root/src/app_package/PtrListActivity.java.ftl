package ${packageName};

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;

<#if applicationPackage??>
import ${applicationPackage}.R;
</#if>
import com.babypat.TitleActivity;
import com.babypat.common.Api;
import com.babypat.common.JsonCallbackWrap;
import com.babypat.db.bean.SystemMessage;
import com.babypat.header.PullToRefreshUtil;
import com.babypat.net.bean.NoticeResponse;
import com.common.library.llj.UniversalAdapter.ListBasedAdapterWrap;
import com.common.library.llj.loadmore.LoadMoreContainer;
import com.common.library.llj.loadmore.LoadMoreHandler;
import com.common.library.llj.loadmore.LoadMoreRecyclerContainer;
import com.common.library.llj.okhttp.OkHttpUtils;
import com.common.library.llj.okhttp.https.HttpParams;
import com.common.library.llj.recyclerview.LinerDivideItemDecoration;
import com.common.library.llj.utils.ListUtil;
import com.llj.adapter.converter.UniversalConverterFactory;
import com.llj.adapter.util.ViewHolderHelper;

import java.util.ArrayList;

import butterknife.BindView;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;
import okhttp3.Call;
import okhttp3.Response;

public class ${activityClass} extends ${superClass} {
    @BindView(R.id.ptrFrameLayout) PtrFrameLayout            mPtrFrameLayout;
    @BindView(R.id.recyclerView)   RecyclerView              mRecyclerView;
    @BindView(R.id.load_more)      LoadMoreRecyclerContainer mLoadMore;

    private DataListAdapter mDataListAdapter;

    private Long mOffset;

    @Override
    public int getLayoutId() {
        return R.layout.${layoutName};
    }

    @Override
    public void initViews(Bundle savedInstanceState) {
        PullToRefreshUtil.initPtrFrameLayoutHeader(mPtrFrameLayout, mBaseFragmentActivity);
        mPtrFrameLayout.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                mOffset = null;
                getData();
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mLoadMore.setLoadMoreHandler(new LoadMoreHandler() {
            @Override
            public void onLoadMore(LoadMoreContainer loadMoreContainer) {
                getData();
            }
        });

        mDataListAdapter = new DataListAdapter();
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mBaseFragmentActivity, LinearLayoutManager.VERTICAL, false));
        mRecyclerView.addItemDecoration(new LinerDivideItemDecoration(mBaseFragmentActivity, LinerDivideItemDecoration.VERTICAL_LIST, R.drawable.shape_invite_family_divider));
        UniversalConverterFactory.create(mDataListAdapter, mRecyclerView);

        mPtrFrameLayout.autoRefresh(true);
    }

    private void getData() {
        HttpParams httpParams = new HttpParams();

        OkHttpUtils.get()
                .tag(mBaseFragmentActivity)
                .params(httpParams)
                .url(Api.EMOTION_SHARE_URL)
                .build()
                .execute(new JsonCallbackWrap<NoticeResponse>(NoticeResponse.class) {

                    @Override
                    public boolean showDialog() {
                        return true;
                    }

                    @Override
                    public void onSuccess(NoticeResponse response) {
                        sendShowDialogMessage(false);
                        initList(response);
                    }

                    @Override
                    public void onFailure(Call call, Response response, Exception exception) {
                        super.onFailure(call, response, exception);
                        sendShowDialogMessage(false);
                    }
                });
    }

    private void initList(NoticeResponse response) {
        if (mOffset == null) {
            mDataListAdapter.clear();
        }
        mDataListAdapter.tryToRemoveBottomLoadMoreView();

        if (response.getData() != null && !ListUtil.isEmpty(response.getData().getList())) {
            mDataListAdapter.addAll(response.getData().getList());
            mOffset = response.getData().getNextOffset();
        } else {
            mOffset = -1L;
        }
        mDataListAdapter.setBottomLoadMoreFinishFlag(mOffset, mLoadMore);

        setEmptyLayout();
    }

    private void setEmptyLayout() {
        if (mDataListAdapter.size() == 0) {   //没有数据
            mLoadMore.setVisibility(View.INVISIBLE);
        } else {
            mLoadMore.setVisibility(View.VISIBLE);
        }
    }

    private class DataListAdapter extends ListBasedAdapterWrap<SystemMessage, ViewHolderHelper> {

        public DataListAdapter() {
            super(new ArrayList<SystemMessage>());
            addItemLayout(new LayoutConfig(R.layout.reach_bottom_load_more_item, VIEW_TYPE_LOADING));
        }

        @Override
        protected void onBindViewHolder(ViewHolderHelper viewHolder, SystemMessage systemMessage, int position) {

        }
    }

}
