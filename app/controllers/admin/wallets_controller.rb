class Admin::WalletsController < ApplicationController
  before_action :authenticate_user!
  #before_action :ensure_admin!

  def index
    @wallets = Wallet.includes(:user).all
    @transactions = WalletTransaction.includes(:wallet).order(created_at: :desc).paginate(per_page: 10, page: params[:page] || 1)
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
