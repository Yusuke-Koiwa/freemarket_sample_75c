// 画像読み込みの必要がないので"load"イベントじゃなく"DOMContentLoaded"
$(document).on('turbolinks:load',function(){

  //id名が"payment_card_submit-button"というボタンが押されたらノードを取得
  // "document"は開いているWebページのDOMツリーが入っているオブジェクト
  // let submit = document.getElementById("payment_card_submit-button");
  // payjpの公開鍵をセット
  Payjp.setPublicKey('pk_test_1505a12ddfdefed5da5d58ab');
  //ボタンが押されたらトークン作成開始。
  // submit.addEventListener('click', function(e){ 
  $("#payment_card_submit-button").on("click",function(e){
    //ボタンを1度無効化
    e.preventDefault(); 
    //入力されたカード情報を取得(id名の記載ミスに注意！)
    let card = { 
        number: $("#payment_card_no").val(), //valueプロパティで文字列の値を取得
        cvc: $("#payment_card_cvc").val(),
        exp_month: $("#payment_card_month").val(),
        exp_year: $("#payment_card_year").val()
    };
    
    // トークンを生成
    Payjp.createToken(card, function(status, response) {  
      if (status === 200) { //成功した場合(status === 200はリクエストが成功している状況です。)
        //データを自サーバにpostしないようにremoveAttr("name")で削除
        $("#payment_card_no").removeAttr("name");
        $("#payment_card_cvc").removeAttr("name");
        $("#payment_card_month").removeAttr("name");
        $("#payment_card_year").removeAttr("name"); 
        var token = response.id;
        $("#charge-form").append($('<input type="hidden" name="payjp_token" class="payjp-token" />').val(token));
        $("#charge-form").get(0).submit();
      } else {
        alert("カード情報が正しくありません。"); //エラー確認用
      }
    });
  });
});