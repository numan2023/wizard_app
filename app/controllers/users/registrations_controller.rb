# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # コメントアウトしている箇所は継承されるクラスに定義されたもの
  # 同名のメソッド定義で、コメントアウト部分を上書き
  # 以下の"super"は、継承されたクラスのメソッドを呼び出すことができる
  def new 
    @user = User.new
  end

  def create
    # 1ページ目で入力した情報のバリデーションチェック
      # 1ページ目から送られてきたパラメーターをインスタンス変数@userに代入
    @user = User.new(sign_up_params)
      #valid?でバリデーション違反がないかどうかをチェック
      unless @user.valid?
        # バリデーション違反次は、false -> newを表示
        #return：メソッドの実行を終了させ、以下の記述を実行しないようにする -> 理由）renderが2回実行されるエラー(DoubleRenderError)を防ぐため。
        render :new, status: :unprocessable_entity and return
      end
    # 1ページ目で入力した情報をsessionに保持 / 最後のページまで遷移した後に保存させるために、sessionを使用
      # sessionにハッシュオブジェクト形式で情報を保存
      # データ整形のため、attributesメソッドを使用：インスタンスメソッドから取得できる値をオブジェクト型からハッシュ型に変換できるメソッド -> 方によって取得できる値が異なる。
        # 例：Userインスタンスがもつオブジェクト型の値
        #=><user:000000000>
        # 例：Userインスタンスがもつハッシュ型の値
        #=> {name=>"tanaka", :age=>"25", gender=>”women”}
    session["devise.regist_data"] = {user: @user.attributes}
      # attributesメソッドでデータ整形の際、パスワード情報が含まれていないため、再度代入する。
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    # 次の住所情報登録で使用するインスタンスを生成し、該当ページへ遷移
      # build_addressで生成したインスタンス@userに紐づくAddressモデルのインスタンスを生成
    @address = @user.build_address
      # 住所情報登録ページへ遷移 & status: :acceptedは処理を正しく受け取ったが、まだ完了していないことを表示。
    render :new_address, status: :accepted
  end

  def create_address
      # 2ページ目で入力した住所情報のバリデーションチェック
    @user = User.new(session["devise.regist_data"]["user"])
    @address = Address.new(address_params)
      unless @address.valid?
        render :new_address, status: unprocessable_entity and return
      end
      # バリデーションチェックが完了した情報とsessionで保持していた情報を合わせ、ユーザー情報として保存
      @user.build_address(@address.attributes) # buildメソッドについて：https://sakaishun.com/2021/03/19/build-method/を参照
      @user.save
      # sessionを削除
      session["devise.regist_data"]["user"].clear
      # ログイン
      sign_in(:user, @user)
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :address)
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
