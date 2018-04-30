package com.devtalha.aiainsurance;

import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.CompoundButton;
import android.widget.Switch;

import java.util.List;

import adapters.RecyclerViewAdapter;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import services.APIClient;
import services.APIInterface;
import vo.Item;
import vo.ResponseVO;
/**
 * Created by Talha Qamar on 4/29/2018.
 * CopyRights: Devtalha.com
 * Email: talha.kicsit18@gmail.com
 */

public class MainActivity extends AppCompatActivity {

    APIInterface apiInterface;
    private RecyclerView mRecyclerView;
    private RecyclerViewAdapter mAdapter;
    private RecyclerView.LayoutManager mLayoutManager;
    private static boolean ischecked = false;
    Switch conditionswitch;
    List<Item> responceItemsData;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        apiInterface = APIClient.getClient().create(APIInterface.class);
        mRecyclerView = (RecyclerView) findViewById(R.id.my_recycler_view);
        mRecyclerView.setHasFixedSize(true);
        mLayoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(mLayoutManager);
        conditionswitch = (Switch) findViewById(R.id.condition);
        conditionswitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean ischeck) {
                if(ischeck){
                    ischecked = true;
                    mAdapter = new RecyclerViewAdapter(responceItemsData,ischecked);
                    mRecyclerView.setAdapter(mAdapter);
                    // mAdapter.swap(responceItemsData,ischecked);
                }
            }
        });
       // getData("teacher");

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        getMenuInflater().inflate(R.menu.menu_main, menu);

        MenuItem search = menu.findItem(R.id.search);
        SearchView searchView = (SearchView) MenuItemCompat.getActionView(search);
        search(searchView);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        return super.onOptionsItemSelected(item);
    }

    private void search(SearchView searchView) {

        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                    getData(query);
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                //getData(newText);
                return true;
            }
        });
    }

    void getData(String data){
        try {
            Call<ResponseVO> call = apiInterface.getResult(data);
            call.enqueue(new Callback<ResponseVO>() {
                @Override
                public void onResponse(Call<ResponseVO> call, Response<ResponseVO> response) {
                    if (response.body() != null) {
                        responceItemsData = response.body().getData().getItems();
                        mAdapter = new RecyclerViewAdapter(responceItemsData,ischecked);
                        mRecyclerView.setAdapter(mAdapter);
                    }
                }

                @Override
                public void onFailure(Call<ResponseVO> call, Throwable t) {
                    call.cancel();
                }
            });
        }catch (Throwable ex){
            ex.printStackTrace();
        }
    }
}
