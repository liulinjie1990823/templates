<?xml version="1.0" encoding="utf-8"?>
<in.srain.cube.views.ptr.PtrFrameLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/ptrFrameLayout"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/white">

    <FrameLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent">

        <com.common.library.llj.loadmore.LoadMoreRecyclerContainer
            android:id="@+id/load_more"
            android:layout_width="match_parent"
            android:layout_height="match_parent">

            <android.support.v7.widget.RecyclerView
                android:id="@+id/recyclerView"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:clipToPadding="false"
                android:scrollbars="none"/>
        </com.common.library.llj.loadmore.LoadMoreRecyclerContainer>
    </FrameLayout>
</in.srain.cube.views.ptr.PtrFrameLayout>
