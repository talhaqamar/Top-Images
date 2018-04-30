package adapters;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.devtalha.aiainsurance.R;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.List;

import vo.Image;
import vo.Item;
import vo.ResponseVO;

/**
 * Created by Talha Qamar on 4/29/2018.
 * CopyRights: Devtalha.com
 * Email: talha.kicsit18@gmail.com
 */

public class RecyclerViewAdapter extends RecyclerView.Adapter<RecyclerViewAdapter.MyViewHolder> {

    private List<Item> List;
    boolean ischecked = false;

    public class MyViewHolder extends RecyclerView.ViewHolder {
        public TextView textViewtitle;
        public TextView textViewdate;
        public TextView textViewmoreimages;
        public ImageView image;
        LinearLayout ChildViews;

        public MyViewHolder(View view) {
            super(view);
            textViewtitle = (TextView) view.findViewById(R.id.textViewtitle);
            textViewdate = (TextView) view.findViewById(R.id.textViewdate);
            textViewmoreimages = (TextView) view.findViewById(R.id.textViewmoreimages);
            image = (ImageView) view.findViewById(R.id.image);
            ChildViews = (LinearLayout) view.findViewById(R.id.ChildViews);
        }
    }

    public RecyclerViewAdapter(List<Item> cList,boolean ischecked) {
        this.List = cList;
        this.ischecked = ischecked;
    }
    public void swap(List list,boolean ischecked){
        if (List != null) {
            List.clear();
            List.addAll(list);
        }
        else {
            List = list;
        }
        notifyDataSetChanged();
    }
    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        Item c = List.get(position);

        holder.textViewtitle.setText(c.getTitle());
        holder.textViewdate.setText(String.valueOf(c.getDatetime()));
        if(null != c.getImages())
        holder.textViewmoreimages.setText("1 of " + String.valueOf(c.getImages().size()));


        if(null !=c.getImages() && c.getImages().size()>1){
           for(int i = 1;i<c.getImages().size();i++){
               if(ischecked){
                    if((c.getPoints()+c.getScore()+c.getTopicId())%2 == 0){
                        inflateChildViews(holder.ChildViews, c.getImages().get(i),c, ""+(i+1)+" of "+ String.valueOf(c.getImages().size()));
                    }
               }else
                   inflateChildViews(holder.ChildViews, c.getImages().get(i),c, ""+(i+1)+" of "+ String.valueOf(c.getImages().size()));

           }
        }else{
            if(null != c.getImages())
            Picasso.get().load(c.getImages().get(0).getLink()).into(holder.image);
        }


    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.items_view,parent, false);
        return new MyViewHolder(v);
    }
    @Override
    public int getItemCount() {
        return List.size();
    }

    void inflateChildViews(LinearLayout parent,Image img,Item item,String totaimg){
        View childviews = LayoutInflater.from(parent.getContext()).inflate(R.layout.items_view,null, false);
        TextView textViewtitle = (TextView) childviews.findViewById(R.id.textViewtitle);
        TextView textViewdate = (TextView) childviews.findViewById(R.id.textViewdate);;
        TextView textViewmoreimages = (TextView) childviews.findViewById(R.id.textViewmoreimages);;
        ImageView image = (ImageView) childviews.findViewById(R.id.image);
        textViewtitle.setText(item.getTitle());
        textViewdate.setText(String.valueOf(item.getDatetime()));
        Picasso.get().load(img.getLink()).into(image);
        textViewmoreimages.setText(totaimg);

        parent.addView(childviews);

    }

}