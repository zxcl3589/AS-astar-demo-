package
{
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.Float;
	
	/**
	 * 逆波兰，计算字符串表达式的值<br/>
	 * 例如<b>mathExpression("10 + 2 * (3 + 15 / 3) - 5 + 6 * 2")</b>
	 * @author lqh 
	 * 
	 */
	public class PrefixExpressionTest{
		/** 运算符栈（模拟栈先进后出） */
		private var signStack:StackLink;
		/** 操作数栈（模拟栈先进后出） */
		private var numStack:StackLink;
		/** 源队列，这里是原始拆分数组，模拟一个队列 */
		private var sourceArr:Array;
		
		/** 操作符优先级hash表  */
		private var signPriority:Dictionary;
		private static var instance:PrefixExpressionTest;
		public function PrefixExpressionTest(h:Hide){
			if(!h){
				throw new Error("you can not new this class,please use PrefixExpressionTest.getInstance() get this obj!!");
			}
			signPriority = new Dictionary();
			signPriority["*"] = 10;
			signPriority["/"] = 10;
			signPriority["+"] = 11;
			signPriority["-"] = 11;
			signPriority["("] = 1;
			signPriority[")"] = 1;
		}
		public static function getInstance():PrefixExpressionTest{
			if(!instance){
				instance = new PrefixExpressionTest(new Hide());
			}
			return instance;
		}
		/** 去掉空字符（包括英文的空格和汉字输入法的空格）串正则表达 */
		private var myPattern:RegExp = /[\s ]*/g;
		/** 正则表达式 搜索算术表达式中的符号 */
		private var spliceRegExp:RegExp = /[\+\-\*()\/]/;
		
		/**
		 * 计算表达式，会自动忽略空白字符串
		 * @param expression：表达式
		 * @return计算结果
		 */
		public function mathExpression(expression:String):Number{
			//首先去掉空格
			expression = expression.replace(myPattern,"");
			//开始表达式批分成数组
			var endIndex:int = expression.search(spliceRegExp);
			//表达式错误
			if(endIndex < 0){
				throw new Error("expression is wrong!!");
				return undefined;
			}
			sourceArr = new Array();
			var i:int=0;
			//解析字符串，把操作符和数字分开
			while(endIndex >= 0){
				endIndex == 0 ? endIndex++ : null;
				sourceArr[i] = expression.substr(0,endIndex);
				if((sourceArr[i] as String).search(spliceRegExp) < 0){
					sourceArr[i] = Number(sourceArr[i]);
				}
				expression = expression.substring(endIndex);
				endIndex = expression.search(spliceRegExp);
				i++;
			}
			sourceArr[i] = expression;
			return operate();
		}
		/**
		 * 计算表达式
		 */
		private function operate():Number{
			signStack = new StackLink();
			numStack = new StackLink();
			
			var temp:* = sourceArr.shift();
			//进行入栈操作
			while(temp){
				pushStack(temp);
				temp = sourceArr.shift();
			}
			//如果上面计算完后，操作数栈还有2个以上数，继续出栈操作，直到操作数栈只有一个数为止
			while(numStack.length > 1){
				shiftStack();
			}
			var backnum:Number = numStack.shift();
			if(signStack.length > 0){
				throw new Error("expression is wrong!please check the expression!");
			}
			signStack = null;
			numStack = null;
			return backnum;
		}
		/** 压栈 */
		private function pushStack(temp:*):void{
			switch(temp){
				case "*":
				case "/":
				case "+":
				case "-":
					/**如果操作符栈顶是 “（” 或者 栈顶的操作符优先级比当前操作符优先级低则压入栈*/
					if(signStack.head == null || signStack.head.obj == "(" || signPriority[temp] < signPriority[signStack.head.obj]){ //值越小优先级越高
						signStack.push(temp);
					}else{ //否则计算栈里的值
						shiftStack();
						pushStack(temp);
					}
					break;
				case "(": /** 左括号直接压入栈顶  */
					signStack.push(temp);
					break;
				case ")": /** 右括号则开始出栈计算值，直到遇到左括号为止 */
					shiftStack(true);
					break;
				default: /** 将操作数压入栈顶 */
					numStack.push(temp);
					break;
			}
		}
		/** 出栈 */
		private function shiftStack(key:Boolean = false):void{
			var temp:*= signStack.shift();
			var value:Number;
			if(temp == "("){
				key = false;
			}else{
				var endnum:Number = numStack.shift();
				var headnum:Number = numStack.shift();
				
				switch(temp){
					case "*":
						value = headnum * endnum;
						break;
					case "/":
						value = headnum / endnum;
						break;
					case "+":
						value = headnum + endnum;
						break;
					case "-":
						value = headnum - endnum;
						break;
				}
				numStack.push(value);
			}
			if(key){
				shiftStack(true);
			}
		}
	}
}
class Hide{}