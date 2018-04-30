package services;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.Path;
import vo.ResponseVO;

/**
 * Created by Talha Qamar on 4/29/2018.
 * CopyRights: Devtalha.com
 * Email: talha.kicsit18@gmail.com
 */

public interface APIInterface {
    @Headers("Authorization: Client-ID 6046ae1df183471")
    @GET("{searchterm}/week/1")
    Call<ResponseVO> getResult(@Path("searchterm") String term);
}
