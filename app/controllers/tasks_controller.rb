class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy] 
  before_action :require_user_logged_in
  #before_action :correct_user, only: [:destroy]

  def index
    if logged_in?
      @user = current_user
      @task = current_user.tasks.build  # form_for 用
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new 
  end

  def create
      @task = Task.new(task_params)

    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを追加しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクの追加に失敗しました。'
      render 'tasks/index'
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_back(fallback_location: root_path)
  end

private
  def set_task
    #@task = Task.find(params[:id])
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task #変数名は実は何でもOKです。大事なのは、 [@aaa]がviewファイルで使えるということ(コントローラで宣言&代入し
      redirect_to root_url
    end
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end